#!/usr/bin/env node

const puppeteer = require('puppeteer');

function findChromiumPath() {
  const { execSync } = require('child_process');

  // Common Chromium executable names and paths
  const chromiumCandidates = [
    'chromium',
    'chromium-browser',
    'google-chrome',
    'google-chrome-stable',
    '/Applications/Chromium.app/Contents/MacOS/Chromium',
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  ];

  // Try to find an available executable
  for (const candidate of chromiumCandidates) {
    try {
      // Check if it's a full path
      if (candidate.startsWith('/')) {
        const fs = require('fs');
        if (fs.existsSync(candidate)) {
          return candidate;
        }
      } else {
        // Check if it's in PATH and get the full path
        const fullPath = execSync(`which ${candidate}`, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
        return fullPath;
      }
    } catch (error) {
      // Continue to next candidate
    }
  }

  // Fallback to macOS default if nothing found
  return '/Applications/Chromium.app/Contents/MacOS/Chromium';
}

async function fetchHTML(url, options = {}) {
  const {
    timeout = 30000,
    debugPort = 9222,
    waitForSelector = null,
    verbose = false,
    mode = 'connect', // 'connect', 'headless', or 'visible'
    chromiumPath = findChromiumPath(),
    closeTab = false
  } = options;

  let browser;
  let page;
  let ownsBrowser = false;

  try {
    if (mode === 'connect') {
      if (verbose) {
        console.error(`Connecting to existing Chromium on port ${debugPort}...`);
      }

      browser = await puppeteer.connect({
        browserURL: `http://localhost:${debugPort}`,
        defaultViewport: null
      });
    } else {
      if (verbose) {
        console.error(`Launching Chromium in ${mode} mode...`);
      }

      const launchOptions = {
        executablePath: chromiumPath,
        headless: mode === 'headless',
        defaultViewport: null,
        userDataDir: `${process.env.HOME}/.config/chromium-get-webpage`, // Shared persistent directory
        args: mode === 'visible' ? [
          '--remote-debugging-port=9223', // Different port to avoid conflicts
          '--remote-allow-origins=*'
        ] : []
      };

      browser = await puppeteer.launch(launchOptions);
      ownsBrowser = true;
    }

    if (verbose) {
      console.error('Creating new page...');
    }

    page = await browser.newPage();

    if (verbose) {
      console.error(`Navigating to: ${url}`);
    }

    const response = await page.goto(url, {
      waitUntil: 'networkidle0',
      timeout: timeout
    });

    // Check for unauthorized or authentication required
    const statusCode = response.status();
    const finalUrl = page.url();

    if (verbose) {
      console.error(`Response status: ${statusCode}`);
      console.error(`Final URL: ${finalUrl}`);
    }

    // Detect if we need authentication
    const needsAuth = await detectAuthenticationRequired(page, statusCode, finalUrl, verbose);

    if (needsAuth && mode !== 'visible') {
      throw new Error('AUTHENTICATION_REQUIRED');
    }

    // If authentication is needed and we're in visible mode, leave browser open and exit
    if (needsAuth && mode === 'visible') {
      if (verbose) {
        console.error('Authentication required - browser window left open for you to sign in');
        console.error('Please sign in and then run the command again');
      }

      // Don't close the browser - user is now in control
      // Set flags to prevent cleanup
      ownsBrowser = false; // Prevent browser from being closed
      page = null; // Prevent page from being closed

      throw new Error('AUTHENTICATION_BROWSER_OPENED');
    }

    if (waitForSelector) {
      if (verbose) {
        console.error(`Waiting for selector: ${waitForSelector}`);
      }
      await page.waitForSelector(waitForSelector, { timeout: timeout });
    }

    if (verbose) {
      console.error('Extracting HTML content...');
    }

    const html = await page.content();

    if (verbose) {
      console.error(`Successfully fetched ${html.length} characters`);
    }

    return { html, statusCode, finalUrl, needsAuth };

  } catch (error) {
    if (error.message === 'AUTHENTICATION_REQUIRED') {
      throw error;
    }
    throw new Error(`Failed to fetch HTML: ${error.message}`);
  } finally {
    // Only close the page/tab if explicitly requested or in headless mode
    const shouldClosePage = closeTab || mode === 'headless';

    if (page && shouldClosePage) {
      try {
        if (verbose) {
          console.error('Closing page/tab...');
        }
        await page.close();
      } catch (closeError) {
        if (verbose) {
          console.error(`Warning: Failed to close page: ${closeError.message}`);
        }
      }
    } else if (page && verbose) {
      console.error('Leaving page/tab open for user management');
    }
    if (browser && ownsBrowser) {
      try {
        await browser.close();
      } catch (closeError) {
        if (verbose) {
          console.error(`Warning: Failed to close browser: ${closeError.message}`);
        }
      }
    } else if (browser) {
      try {
        await browser.disconnect();
      } catch (disconnectError) {
        if (verbose) {
          console.error(`Warning: Failed to disconnect browser: ${disconnectError.message}`);
        }
      }
    }
  }
}

async function detectAuthenticationRequired(page, statusCode, finalUrl, verbose = false) {
  // Check HTTP status codes that indicate authentication issues
  if ([401, 403].includes(statusCode)) {
    if (verbose) {
      console.error(`Authentication required: HTTP ${statusCode}`);
    }
    return true;
  }

  // Check for common authentication-related redirects and content
  try {
    const title = await page.title();
    const bodyText = await page.evaluate(() => document.body?.textContent?.toLowerCase() || '');

    // Look for authentication indicators in the page title (more reliable)
    const titleAuthIndicators = [
      'sign in',
      'login',
      'authenticate',
      'unauthorized',
      'access denied',
      'permission denied'
    ];

    // Look for authentication prompts in the body (more specific phrases)
    const bodyAuthIndicators = [
      'please sign in',
      'please log in',
      'you must sign in',
      'you must log in',
      'requires login',
      'login to continue',
      'sign in to continue'
    ];

    const titleLower = title.toLowerCase();
    const hasTitleAuth = titleAuthIndicators.some(indicator => titleLower.includes(indicator));
    const hasBodyAuth = bodyAuthIndicators.some(indicator => bodyText.includes(indicator));

    const hasAuthIndicator = hasTitleAuth || hasBodyAuth;

    // Check for common auth URLs
    const authUrlPatterns = [
      /accounts\.google\.com/,
      /login\./,
      /auth\./,
      /signin/,
      /oauth/
    ];

    const hasAuthUrl = authUrlPatterns.some(pattern => pattern.test(finalUrl));

    if (verbose && (hasAuthIndicator || hasAuthUrl)) {
      console.error(`Authentication indicators detected: title="${title}", hasTitleAuth=${hasTitleAuth}, hasBodyAuth=${hasBodyAuth}, hasAuthUrl=${hasAuthUrl}`);
      if (hasBodyAuth) {
        const matchedIndicator = bodyAuthIndicators.find(indicator => bodyText.includes(indicator));
        console.error(`Body auth indicator found: "${matchedIndicator}"`);
      }
    }

    return hasAuthIndicator || hasAuthUrl;
  } catch (error) {
    if (verbose) {
      console.error(`Error detecting authentication: ${error.message}`);
    }
    return false;
  }
}

async function isChromiumRunning(debugPort = 9222) {
  try {
    const response = await fetch(`http://localhost:${debugPort}/json/version`);
    return response.ok;
  } catch {
    return false;
  }
}

function parseArguments() {
  const args = process.argv.slice(2);

  if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
    console.error(`Usage: node fetch-html.js <url> [options]

Options:
  --timeout <ms>        Page load timeout in milliseconds (default: 30000)
  --debug-port <port>   Chromium debug port (default: 9222)
  --wait-for <selector> Wait for CSS selector before extracting HTML
  --close-tab           Close the browser tab after fetching content
  --mode <mode>         Operation mode: connect, headless, visible (default: connect)
  --chromium-path <path> Path to Chromium executable (default: auto-detected)
  --verbose, -v         Enable verbose logging to stderr
  --help, -h            Show this help message

Modes:
  connect    Connect to existing Chromium instance (preserves session)
  headless   Launch headless Chromium (no GUI, standalone)
  visible    Launch visible Chromium (for authentication)

Examples:
  node fetch-html.js https://example.com
  node fetch-html.js https://example.com --mode headless
  node fetch-html.js https://app.example.com --mode visible --wait-for ".content-loaded"
`);
    process.exit(args.includes('--help') || args.includes('-h') ? 0 : 1);
  }

  const options = {
    url: args[0],
    timeout: 30000,
    debugPort: 9222,
    waitForSelector: null,
    verbose: false,
    mode: 'connect',
    chromiumPath: findChromiumPath(),
    closeTab: false
  };

  for (let i = 1; i < args.length; i++) {
    switch (args[i]) {
      case '--timeout':
        options.timeout = parseInt(args[++i], 10);
        if (isNaN(options.timeout)) {
          throw new Error('Invalid timeout value');
        }
        break;
      case '--debug-port':
        options.debugPort = parseInt(args[++i], 10);
        if (isNaN(options.debugPort)) {
          throw new Error('Invalid debug port value');
        }
        break;
      case '--wait-for':
        options.waitForSelector = args[++i];
        break;
      case '--close-tab':
        options.closeTab = true;
        break;
      case '--mode':
        options.mode = args[++i];
        if (!['connect', 'headless', 'visible'].includes(options.mode)) {
          throw new Error('Mode must be: connect, headless, or visible');
        }
        break;
      case '--chromium-path':
        options.chromiumPath = args[++i];
        break;
      case '--verbose':
      case '-v':
        options.verbose = true;
        break;
      default:
        throw new Error(`Unknown option: ${args[i]}`);
    }
  }

  if (!options.url || !options.url.startsWith('http')) {
    throw new Error('URL must start with http:// or https://');
  }

  return options;
}

async function main() {
  try {
    const options = parseArguments();
    const result = await fetchHTML(options.url, options);

    // Output just the HTML content
    console.log(result.html);

    // If authentication was detected but not handled, exit with special code
    if (result.needsAuth && options.mode !== 'visible') {
      process.exit(2); // Special exit code for authentication required
    }
  } catch (error) {
    if (error.message === 'AUTHENTICATION_REQUIRED') {
      console.error('Authentication required for this page');
      process.exit(2);
    }
    if (error.message === 'AUTHENTICATION_BROWSER_OPENED') {
      console.error('Browser opened for authentication - please sign in and run the command again');
      process.exit(3); // Special exit code for browser left open
    }
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { fetchHTML, isChromiumRunning, detectAuthenticationRequired };