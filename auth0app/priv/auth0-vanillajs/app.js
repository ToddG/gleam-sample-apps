import { createAuth0Client } from '@auth0/auth0-spa-js';

// DOM elements
const loading = document.getElementById('loading');
const error = document.getElementById('error');
const errorDetails = document.getElementById('error-details');
const app = document.getElementById('app');
const loggedOutSection = document.getElementById('logged-out');
const loggedInSection = document.getElementById('logged-in');
const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const profileContainer = document.getElementById('profile');

let auth0Client;

// Initialize Auth0 client
async function initAuth0() {
  try {
    auth0Client = await createAuth0Client({
      domain: import.meta.env.VITE_AUTH0_DOMAIN,
      clientId: import.meta.env.VITE_AUTH0_CLIENT_ID,
      authorizationParams: {
        redirect_uri: window.location.origin
      }
    });

    // Check if user is returning from login
    if (window.location.search.includes('code=') && window.location.search.includes('state=')) {
      await handleRedirectCallback();
    }

    // Update UI based on authentication state
    await updateUI();
  } catch (err) {
    showError(err.message);
  }
}

// Handle redirect callback
async function handleRedirectCallback() {
  try {
    await auth0Client.handleRedirectCallback();
    // Clean up the URL to remove query parameters
    window.history.replaceState({}, document.title, window.location.pathname);
  } catch (err) {
    showError(err.message);
  }
}

// Update UI based on authentication state
async function updateUI() {
  try {
    const isAuthenticated = await auth0Client.isAuthenticated();

    if (isAuthenticated) {
      showLoggedIn();
      await displayProfile();
    } else {
      showLoggedOut();
    }

    hideLoading();
  } catch (err) {
    showError(err.message);
  }
}

// Display user profile
async function displayProfile() {
  try {
    const user = await auth0Client.getUser();
    const placeholderImage = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='110' height='110' viewBox='0 0 110 110'%3E%3Ccircle cx='55' cy='55' r='55' fill='%2363b3ed'/%3E%3Cpath d='M55 50c8.28 0 15-6.72 15-15s-6.72-15-15-15-15 6.72-15 15 6.72 15 15 15zm0 7.5c-10 0-30 5.02-30 15v3.75c0 2.07 1.68 3.75 3.75 3.75h52.5c2.07 0 3.75-1.68 3.75-3.75V72.5c0-9.98-20-15-30-15z' fill='%23fff'/%3E%3C/svg%3E`;

    profileContainer.innerHTML = `
      <div style="display: flex; flex-direction: column; align-items: center; gap: 1rem;">
        <img 
          src="${user.picture || placeholderImage}" 
          alt="${user.name || 'User'}" 
          class="profile-picture"
          style="
            width: 110px; 
            height: 110px; 
            border-radius: 50%; 
            object-fit: cover;
            border: 3px solid #63b3ed;
          "
          onerror="this.src='${placeholderImage}'"
        />
        <div style="text-align: center;">
          <div class="profile-name" style="font-size: 2rem; font-weight: 600; color: #f7fafc; margin-bottom: 0.5rem;">
            ${user.name || 'User'}
          </div>
          <div class="profile-email" style="font-size: 1.15rem; color: #a0aec0;">
            ${user.email || 'No email provided'}
          </div>
        </div>
      </div>
    `;
  } catch (err) {
    console.error('Error displaying profile:', err);
  }
}

// Event handlers
async function login() {
  try {
    await auth0Client.loginWithRedirect();
  } catch (err) {
    showError(err.message);
  }
}

async function logout() {
  try {
    await auth0Client.logout({
      logoutParams: {
        returnTo: window.location.origin
      }
    });
  } catch (err) {
    showError(err.message);
  }
}

// UI state management
function showLoading() {
  loading.style.display = 'block';
  error.style.display = 'none';
  app.style.display = 'none';
}

function hideLoading() {
  loading.style.display = 'none';
  app.style.display = 'flex';
}

function showError(message) {
  loading.style.display = 'none';
  app.style.display = 'none';
  error.style.display = 'block';
  errorDetails.textContent = message;
}

function showLoggedIn() {
  loggedOutSection.style.display = 'none';
  loggedInSection.style.display = 'flex';
}

function showLoggedOut() {
  loggedInSection.style.display = 'none';
  loggedOutSection.style.display = 'flex';
}

// Event listeners
loginBtn.addEventListener('click', login);
logoutBtn.addEventListener('click', logout);

// Initialize the app
initAuth0();
