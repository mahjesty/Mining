<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Account &amp; Security</title>
  <!-- Include jsOTP for TOTP generation -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jsotp/1.3.1/jsotp.min.js"></script>
  <style>
    /* ---------- Base Reset & Typography ---------- */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: "Roboto", sans-serif;
      background-color: var(--bg-color);
      color: var(--text-color);
      line-height: 1.6;
      transition: background-color 0.3s, color 0.3s;
    }
    /* ---------- Theme Variables ---------- */
    :root {
      --bg-color: #121212;
      --text-color: #e0e0e0;
      --card-bg: #1e1e1e;
      --border-color: #333;
      --accent-color: #4caf50;
      --btn-gradient: linear-gradient(145deg, #4caf50, #66bb6a);
      --btn-hover: linear-gradient(145deg, #43a047, #5cae55);
    }
    body.light-theme {
      --bg-color: #f5f5f5;
      --text-color: #333;
      --card-bg: #fff;
      --border-color: #ccc;
      --accent-color: #4caf50;
      --btn-gradient: linear-gradient(145deg, #ddd, #ccc);
      --btn-hover: linear-gradient(145deg, #bbb, #aaa);
    }
    /* ---------- Helper Classes for Verification ---------- */
    .verified {
      color: green;
    }
    .not-verified {
      color: red;
    }
    /* ---------- Container & Page Layout ---------- */
    .container {
      width: 90%;
      max-width: 480px;
      margin: 20px auto;
      padding: 0 16px;
    }
    .page { display: none; }
    .title-bar {
      position: relative;
      text-align: center;
      padding: 16px 0;
      border-bottom: 1px solid var(--border-color);
      margin-bottom: 20px;
    }
    .title-bar h1 {
      font-size: 1.5rem;
      font-weight: 600;
      color: var(--text-color);
    }
    .back-button {
      position: absolute;
      left: 16px;
      top: 50%;
      transform: translateY(-50%);
      cursor: pointer;
    }
    .back-button svg { width: 24px; height: 24px; fill: var(--text-color); }
    /* ---------- Card & Section Styles ---------- */
    .card, .section, .menu-list, .profile-card {
      background-color: var(--card-bg);
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.4);
    }
    .profile-card { display: flex; align-items: center; }
    .profile-avatar {
      width: 60px; 
      height: 60px; 
      border-radius: 50%;
      overflow: hidden; 
      margin-right: 16px; 
      cursor: pointer;
    }
    .profile-avatar img { width: 100%; height: 100%; object-fit: cover; }
    .profile-details .profile-name {
      font-size: 1.125rem;
      font-weight: 600;
      margin-bottom: 4px;
      color: var(--text-color);
    }
    .profile-details .profile-uid,
    .profile-details .profile-email { font-size: 0.875rem; color: var(--text-color); }
    /* ---------- Menu List ---------- */
    .menu-list { padding: 8px 0; }
    .menu-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 16px;
      border-bottom: 1px solid var(--border-color);
      cursor: pointer;
      transition: background 0.3s ease;
    }
    .menu-item:last-child { border-bottom: none; }
    .menu-item:hover { background-color: #2a2a2a; }
    /* ---------- Button Styles ---------- */
    .btn {
      display: block;
      width: 100%;
      padding: 12px;
      background: var(--btn-gradient);
      color: #000;
      font-size: 1rem;
      font-weight: bold;
      text-align: center;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background 0.3s ease, transform 0.2s ease;
      margin-top: 10px;
    }
    .btn:hover { background: var(--btn-hover); transform: translateY(-2px); }
    /* ---------- Input Group Styles ---------- */
    .input-group {
      display: flex;
      align-items: center;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      overflow: hidden;
      margin-top: 8px;
    }
    .input-group input {
      flex: 1;
      padding: 10px;
      background: var(--bg-color);
      border: none;
      color: var(--text-color);
      font-size: 1rem;
    }
    .input-group button {
      padding: 10px;
      background: var(--accent-color);
      border: none;
      font-size: 1rem;
      font-weight: bold;
      color: #000;
      cursor: pointer;
      border-left: 1px solid var(--border-color);
      transition: background 0.3s ease;
    }
    .input-group button:hover { background: #43a047; }
    /* ---------- Label Styles ---------- */
    .section .label {
      font-size: 1rem;
      font-weight: 600;
      margin-bottom: 6px;
      color: var(--text-color);
    }
    /* ---------- Sensitive Pages ---------- */
    #pageResetPassword .section,
    #pagePayPin .section {
      font-weight: bold;
      border: 2px solid var(--accent-color);
      padding: 20px;
      background-color: var(--card-bg);
    }
    #pageResetPassword .section .label,
    #pagePayPin .section .label {
      font-size: 1.2rem;
    }
    #pageResetPassword .section input,
    #pagePayPin .section input {
      font-size: 1.2rem;
      font-weight: bold;
    }
    /* ---------- VIP Privilege Styles ---------- */
    #pageVip .vip-tier {
      margin-bottom: 20px;
      padding: 16px;
      border: 1px solid var(--border-color);
      border-radius: 8px;
      background-color: var(--card-bg);
    }
    #pageVip .vip-tier h2 {
      font-size: 1.3rem;
      margin-bottom: 10px;
      color: var(--accent-color);
    }
    #pageVip .vip-tier p {
      font-size: 0.95rem;
      margin-bottom: 10px;
      line-height: 1.4;
    }
    #pageVip .vip-tier ul {
      list-style: disc;
      padding-left: 20px;
    }
    #pageVip .vip-tier ul li {
      margin-bottom: 6px;
      font-size: 0.95rem;
    }
    /* ---------- Need Help Page (Advanced Contact) ---------- */
    #pageContact .title-bar h1 {
      font-size: 1.7rem;
      color: var(--accent-color);
    }
    #pageContact .section {
      text-align: center;
    }
    #pageContact .section p {
      font-size: 1.1rem;
      margin-bottom: 20px;
    }
    #pageContact .section .help-btn {
      font-size: 1.2rem;
      padding: 14px;
      margin: 8px 0;
    }
    /* ---------- TOTP Verification Page Styles ---------- */
    #pageTOTPVerification .section input {
      font-size: 1.2rem;
      padding: 15px;
    }
    /* ---------- Modal Styles ---------- */
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.7);
    }
    .modal-content {
      background: var(--card-bg);
      margin: 15% auto;
      padding: 20px;
      border: 1px solid #444;
      width: 90%;
      max-width: 400px;
      border-radius: 8px;
      text-align: center;
    }
    .modal-content .close {
      color: var(--text-color);
      float: right;
      font-size: 1.5rem;
      font-weight: bold;
      cursor: pointer;
    }
    /* ---------- Activity Items ---------- */
    .activity-item {
      background: #272727;
      padding: 12px;
      border-radius: 6px;
      margin-bottom: 10px;
      border-left: 4px solid var(--accent-color);
    }
    .activity-item strong { color: var(--text-color); }
    .activity-item span { color: var(--text-color); font-size: 0.9rem; }
    /* ---------- Devices Container ---------- */
    #devicesList {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      justify-content: space-between;
    }
    .device-item {
      flex: 1 1 calc(50% - 10px);
      background: #272727;
      padding: 12px;
      border-radius: 6px;
      border-left: 4px solid var(--accent-color);
      box-sizing: border-box;
      margin-bottom: 10px;
    }
    /* ---------- Responsive Adjustments ---------- */
    @media (max-width: 480px) {
      .title-bar h1 { font-size: 1.25rem; }
      .btn, .input-group input { font-size: 0.9rem; }
      #devicesList { flex-direction: column; }
      .device-item { flex: 1 1 100%; }
    }
    /* ---------- Preferences Page Custom Styling ---------- */
    #pagePreferences .section .label {
      font-size: 1.3rem;
      font-weight: 700;
      margin-bottom: 10px;
    }
    #pagePreferences .section .value select {
      width: 100%;
      font-size: 1.3rem;
      padding: 14px;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      background-color: var(--bg-color);
      color: var(--text-color);
      margin-top: 4px;
    }
    /* ---------- Advanced Account Profile Styles ---------- */
    .profile-container {
      display: flex;
      flex-direction: column;
      gap: 20px;
    }
    .profile-avatar-large {
      text-align: center;
    }
    .profile-avatar-large img {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      object-fit: cover;
      border: 3px solid var(--accent-color);
    }
    .profile-details-advanced .detail-card {
      background-color: var(--card-bg);
      border: 2px solid var(--accent-color);
      border-radius: 8px;
      padding: 12px;
      margin-bottom: 12px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.3);
    }
    .detail-card .detail-label {
      font-size: 1.1rem;
      font-weight: bold;
      margin-bottom: 4px;
    }
    .detail-card .detail-value {
      font-size: 1.1rem;
    }
  </style>
</head>
<body>
  <!-- ==================== PART 2: HTML Markup for Pages ==================== -->
  
  <!-- Account Info Page -->
  <div id="pageAccountInfo" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showAccountInfoPage()">
          <svg viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path></svg>
        </div>
        <h1>Account &amp; Security</h1>
      </div>
      <div class="profile-card">
        <div class="profile-avatar" onclick="showProfilePage()">
          <img src="https://media.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif" alt="User Avatar">
        </div>
        <div class="profile-details">
          <div class="profile-name" id="profileName">UserName</div>
          <div class="profile-uid" id="profileUID">UID: 000000000</div>
          <div class="profile-email" id="profileEmail">user@example.com</div>
        </div>
      </div>
      <div class="menu-list">
        <div class="menu-item" onclick="showSecurityPage()">
          <span>Security</span>
        </div>
        <div class="menu-item" onclick="showVipPage()">
          <span>VIP Privilege</span>
        </div>
        <div class="menu-item" onclick="showContactPage()">
          <span>Contact</span>
        </div>
      </div>
      <button class="btn">Log Out</button>
    </div>
  </div>
  
  <!-- Advanced Account Profile Page -->
  <div id="pageProfile" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showAccountInfoPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Account Profile</h1>
      </div>
      <div class="profile-container">
        <div class="profile-avatar-large">
          <!-- Default animated profile photo -->
          <img src="https://media.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif" alt="User Animated Avatar">
        </div>
        <div class="profile-details-advanced">
          <div class="detail-card">
            <div class="detail-label">Full Name:</div>
            <div class="detail-value" id="profileNameDetail">UserName</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Username:</div>
            <div class="detail-value" id="profileUsername">Mintingofficial111</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Email Address:</div>
            <div class="detail-value" id="profileEmailDetail">user@example.com</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Phone:</div>
            <div class="detail-value" id="profilePhone">+1 (555) 123-4567</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Member Since:</div>
            <div class="detail-value" id="profileMemberSince">January 2022</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Account Status:</div>
            <div class="detail-value" id="profileStatus">Active</div>
          </div>
          <!-- Additional Professional Details with conditional text colors -->
          <div class="detail-card">
            <div class="detail-label">KYC Verification:</div>
            <div class="detail-value" id="profileKYC">Verified</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Email Verification:</div>
            <div class="detail-value" id="profileEmailVerified">Not Verified</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">Phone Verification:</div>
            <div class="detail-value" id="profilePhoneVerified">Not Verified</div>
          </div>
          <div class="detail-card">
            <div class="detail-label">2FA Enabled:</div>
            <div class="detail-value" id="profile2FA">Enabled</div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- VIP Privilege Page -->
  <div id="pageVip" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showAccountInfoPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>VIP Privileges</h1>
      </div>
      <!-- VIP Bronze Tier -->
      <div class="vip-tier">
        <h2>VIP Bronze</h2>
        <p>As an entry tier, VIP Bronze provides a strong foundation with essential benefits for emerging traders:</p>
        <ul>
          <li>Fee discount: Up to <strong>8%</strong> off trading fees</li>
          <li>Access to standard trading tools</li>
          <li>Real-time market data and charts</li>
          <li>Standard customer support</li>
        </ul>
        <p><strong>Qualification:</strong> Trade at least <strong>$15,000</strong> or maintain an account balance of <strong>$7,500</strong> over the last 30 days.</p>
      </div>
      <!-- VIP Silver Tier -->
      <div class="vip-tier">
        <h2>VIP Silver</h2>
        <p>Upgrade to VIP Silver to enhance your trading experience with advanced features and personalized support:</p>
        <ul>
          <li>Fee discount: Up to <strong>15%</strong> off trading fees</li>
          <li>Advanced trading tools and analytics</li>
          <li>Priority customer support</li>
          <li>Exclusive market insights and research reports</li>
          <li>Invitations to premium trading events</li>
        </ul>
        <p><strong>Qualification:</strong> Achieve a trading volume of at least <strong>$75,000</strong> or maintain a balance of <strong>$35,000</strong> over the last 30 days.</p>
      </div>
      <!-- VIP Gold Tier -->
      <div class="vip-tier">
        <h2>VIP Gold</h2>
        <p>VIP Gold represents our premium tier, offering the most exclusive benefits for high‑volume traders:</p>
        <ul>
          <li>Fee discount: Up to <strong>30%</strong> off trading fees</li>
          <li>Personalized trading advisory with a dedicated account manager</li>
          <li>24/7 VIP customer support</li>
          <li>Access to premium research reports and advanced analytics</li>
          <li>Invitations to exclusive VIP events and special rewards</li>
        </ul>
        <p><strong>Qualification:</strong> Reach a trading volume of at least <strong>$250,000</strong> or maintain an account balance of <strong>$150,000</strong> over the last 30 days.</p>
      </div>
    </div>
  </div>
  
  <!-- Need Help (Advanced Contact) Page -->
  <div id="pageContact" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showAccountInfoPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Need Help?</h1>
      </div>
      <div class="section">
        <p style="font-size:1.1rem; margin-bottom:20px;">
          We're here to help! Choose one of the options below:
        </p>
        <button class="btn help-btn" onclick="window.location.href='mailto:support@example.com'">Email Support</button>
        <button class="btn help-btn" onclick="window.open('https://livechat.example.com','_blank')">Live Chat</button>
        <button class="btn help-btn" onclick="window.location.href='help-articles.html'">Help Articles</button>
      </div>
    </div>
  </div>
  
  <!-- 2FA Setup Page -->
  <div id="pageAuthentication" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>2FA Setup</h1>
      </div>
      <div class="section" id="totpSection">
        <div class="row">
          <div class="label">QR Code:</div>
          <div class="value">
            <img id="authQR" style="width:200px; height:200px; display:block; margin:0 auto;">
          </div>
        </div>
        <div class="row">
          <div class="label">Your TOTP Secret:</div>
          <div class="value">
            <input type="text" id="authKey" readonly style="width:100%; padding:12px; font-size:15px; border:1px solid #333; border-radius:6px; background:#121212; color:#fff;">
          </div>
        </div>
        <button class="btn" onclick="copyAuthKey()">Copy Key &amp; Proceed</button>
      </div>
    </div>
  </div>
  
  <!-- TOTP Verification Page -->
  <div id="pageTOTPVerification" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showAuthenticationPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>2FA Verification</h1>
      </div>
      <div class="section">
        <p style="margin-bottom: 15px;">
          Open your Google Authenticator app, copy the 6‑digit code, then click the button below to paste it.
        </p>
        <div class="row">
          <div class="label">Enter Code:</div>
          <div class="value">
            <input type="text" id="totpCodeInput" placeholder="6-digit code" inputmode="numeric" maxlength="6" style="font-size:1.2rem; padding:15px;">
          </div>
        </div>
        <button class="btn" id="pasteButton">Paste Code from Clipboard</button>
        <button class="btn" onclick="verifyTOTPCode()">Verify Code</button>
      </div>
    </div>
  </div>
  
  <!-- Reset Password Page -->
  <div id="pageResetPassword" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Reset Password</h1>
      </div>
      <div class="section">
        <div class="row" style="margin-bottom: 16px;">
          <div class="label">Enter Your Recovery Email:</div>
          <div class="value">
            <input type="email" id="recoveryEmail" placeholder="your-email@example.com">
          </div>
        </div>
        <button class="btn" onclick="sendRecoveryEmail()">Send Reset Link</button>
      </div>
    </div>
  </div>
  
  <!-- Pay PIN Page -->
  <div id="pagePayPin" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Pay PIN</h1>
      </div>
      <div class="section">
        <p>Please enter your secure 6-digit PIN. This PIN will serve as your transaction authorization key and is stored securely for all payment transactions.</p>
        <div class="row" style="margin-bottom: 16px;">
          <div class="label">Enter Your PIN:</div>
          <div class="value">
            <input type="password" id="payPin" placeholder="••••••" maxlength="6" pattern="[0-9]{6}" inputmode="numeric">
          </div>
        </div>
        <button class="btn" onclick="authenticatePin()">Authenticate PIN</button>
      </div>
    </div>
  </div>
  
  <!-- Edit Phone Number Page -->
  <div id="pageEditPhone" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Edit Phone Number</h1>
      </div>
      <div class="section">
        <div class="row" style="margin-bottom: 16px;">
          <div class="label">Phone Number:</div>
          <div class="value">
            <input type="text" id="editPhone" placeholder="Enter your phone number">
          </div>
        </div>
        <button class="btn" onclick="savePhone()">Save Phone Number</button>
      </div>
    </div>
  </div>
  
  <!-- Account Activities Page -->
  <div id="pageAccountActivities" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Account Activities</h1>
      </div>
      <div class="section" id="activitiesList">
        <!-- Activity items will be populated here -->
      </div>
    </div>
  </div>
  
  <!-- Devices Page -->
  <div id="pageDevices" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Devices</h1>
      </div>
      <div class="section" id="devicesList">
        <!-- Device details will be populated here -->
      </div>
    </div>
  </div>
  
  <!-- Theme Selection Page -->
  <div id="pageTheme" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Theme Settings</h1>
      </div>
      <div class="section">
        <div class="row">
          <div class="label">Select Theme:</div>
          <div class="value">
            <input type="radio" name="theme" value="dark" id="theme-dark">
            <label for="theme-dark">Dark</label><br>
            <input type="radio" name="theme" value="light" id="theme-light">
            <label for="theme-light">Light</label><br>
            <input type="radio" name="theme" value="device" id="theme-device">
            <label for="theme-device">Device Setting</label>
          </div>
        </div>
        <button class="btn" onclick="saveTheme()">Save Theme</button>
      </div>
    </div>
  </div>
  
  <!-- Preferences Page -->
  <div id="pagePreferences" class="page">
    <div class="container">
      <div class="title-bar">
        <div class="back-button" onclick="showSecurityPage()">
          <svg viewBox="0 0 24 24">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"></path>
          </svg>
        </div>
        <h1>Preferences</h1>
      </div>
      <div class="section">
        <div class="row" style="margin-bottom: 16px;">
          <div class="label">Select Currency:</div>
          <div class="value">
            <select id="currencySelect">
              <option value="USD">USD - United States Dollar</option>
              <option value="EUR">EUR - Euro</option>
              <option value="GBP">GBP - British Pound</option>
              <option value="JPY">JPY - Japanese Yen</option>
              <option value="AUD">AUD - Australian Dollar</option>
              <option value="CAD">CAD - Canadian Dollar</option>
              <option value="INR">INR - Indian Rupee</option>
              <option value="CHF">CHF - Swiss Franc</option>
              <option value="CNY">CNY - Chinese Yuan</option>
              <option value="SEK">SEK - Swedish Krona</option>
            </select>
          </div>
        </div>
        <div class="row" style="margin-bottom: 16px;">
          <div class="label">Select Language:</div>
          <div class="value">
            <select id="languageSelect">
              <option value="en">English</option>
              <option value="es">Spanish</option>
              <option value="fr">French</option>
              <option value="de">German</option>
              <option value="it">Italian</option>
              <option value="pt">Portuguese</option>
              <option value="ru">Russian</option>
              <option value="ja">Japanese</option>
              <option value="ko">Korean</option>
              <option value="zh_CN">Chinese (Simplified)</option>
              <option value="zh_TW">Chinese (Traditional)</option>
              <option value="ar">Arabic</option>
            </select>
          </div>
        </div>
        <button class="btn" onclick="savePreferences()">Save Preferences</button>
      </div>
    </div>
  </div>
  
  <!-- Modal for Messages -->
  <div id="messageModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="hideMessage()">&times;</span>
      <p id="messageText"></p>
    </div>
  </div>
  
  <!-- ==================== PART 3: JavaScript Functions ==================== -->
  <script>
    window.addEventListener("DOMContentLoaded", function() {
      /* ---------- Dummy Data ---------- */
      const userData = {
        name: "Mintingofficial111",
        uid: "534206264",
        email: "stan****@gmail.com",
        username: "Mintingofficial111",
        phone: "+1 (555) 123-4567",
        memberSince: "January 2022",
        status: "Active",
        kycVerified: true,
        emailVerified: false,
        phoneVerified: false,
        twoFAEnabled: true
      };
      document.getElementById("profileName").innerText = userData.name;
      document.getElementById("profileUID").innerText = "UID: " + userData.uid;
      document.getElementById("profileEmail").innerText = userData.email;
      
      function populateProfilePage() {
        document.getElementById("profileNameDetail").innerText = userData.name;
        document.getElementById("profileUIDDetail").innerText = userData.uid;
        document.getElementById("profileEmailDetail").innerText = userData.email;
        document.getElementById("profilePhone").innerText = userData.phone;
        document.getElementById("profileMemberSince").innerText = userData.memberSince;
        document.getElementById("profileStatus").innerText = userData.status;
        
        // Set verification details with conditional text colors using classes
        const emailVerText = userData.emailVerified ? "Verified" : "Not Verified";
        const phoneVerText = userData.phoneVerified ? "Verified" : "Not Verified";
        
        const emailEl = document.getElementById("profileEmailVerified");
        emailEl.innerText = emailVerText;
        emailEl.classList.remove("verified", "not-verified");
        emailEl.classList.add(userData.emailVerified ? "verified" : "not-verified");
        
        const phoneEl = document.getElementById("profilePhoneVerified");
        phoneEl.innerText = phoneVerText;
        phoneEl.classList.remove("verified", "not-verified");
        phoneEl.classList.add(userData.phoneVerified ? "verified" : "not-verified");
        
        const kycText = userData.kycVerified ? "Verified" : "Not Verified";
        const kycEl = document.getElementById("profileKYC");
        kycEl.innerText = kycText;
        kycEl.classList.remove("verified", "not-verified");
        kycEl.classList.add(userData.kycVerified ? "verified" : "not-verified");
        
        const twoFAText = userData.twoFAEnabled ? "Enabled" : "Disabled";
        const twoFAEl = document.getElementById("profile2FA");
        twoFAEl.innerText = twoFAText;
        twoFAEl.classList.remove("verified", "not-verified");
        twoFAEl.classList.add(userData.twoFAEnabled ? "verified" : "not-verified");
      }
      
      const activities = [
        { date: "2023-05-01 10:30", description: "Logged in" },
        { date: "2023-05-01 10:35", description: "Changed password" },
        { date: "2023-05-01 11:00", description: "Transferred funds" },
        { date: "2023-05-02 09:20", description: "Viewed account activity" },
        { date: "2023-05-03 14:10", description: "Logged out" }
      ];
      function populateAccountActivities() {
        const list = document.getElementById("activitiesList");
        list.innerHTML = "";
        if (!activities.length) {
          list.innerHTML = "<p>No activities found.</p>";
          return;
        }
        activities.forEach(activity => {
          const item = document.createElement("div");
          item.className = "activity-item";
          item.innerHTML = `<strong>${activity.date}</strong><br><span>${activity.description}</span>`;
          list.appendChild(item);
        });
      }
      const devices = [
        { deviceName: "iPhone 12", deviceType: "Mobile", lastUsed: "2023-06-01 14:30", location: "New York, USA" },
        { deviceName: "MacBook Pro", deviceType: "Laptop", lastUsed: "2023-06-01 10:15", location: "San Francisco, USA" },
        { deviceName: "iPad Air", deviceType: "Tablet", lastUsed: "2023-06-01 12:45", location: "Chicago, USA" }
      ];
      function populateDevices() {
        const list = document.getElementById("devicesList");
        list.innerHTML = "";
        if (!devices.length) {
          list.innerHTML = "<p>No devices found.</p>";
          return;
        }
        devices.forEach(device => {
          const item = document.createElement("div");
          item.className = "device-item";
          item.innerHTML = `<strong>${device.deviceName}</strong> (${device.deviceType})<br>
                            <span>Last Used: ${device.lastUsed}</span><br>
                            <span>Location: ${device.location}</span>`;
          list.appendChild(item);
        });
      }
      
      /* ---------- Navigation Functions ---------- */
      function showPage(pageID) {
        document.querySelectorAll(".page").forEach(page => page.style.display = "none");
        document.getElementById(pageID).style.display = "block";
      }
      window.showAccountInfoPage = function() { showPage("pageAccountInfo"); }
      window.showProfilePage = function() { showPage("pageProfile"); populateProfilePage(); }
      window.showSecurityPage = function() { showPage("pageSecurity"); }
      window.showResetPasswordPage = function() { showPage("pageResetPassword"); document.getElementById("recoveryEmail").value = userData.email; }
      window.showPayPinPage = function() { showPage("pagePayPin"); }
      window.showAccountActivitiesPage = function() { showPage("pageAccountActivities"); populateAccountActivities(); }
      window.showDevicesPage = function() { showPage("pageDevices"); populateDevices(); }
      window.showDeviceLockPage = function() { showPage("pageDeviceLock"); }
      window.showAuthenticationPage = function() { showPage("pageAuthentication"); loadAuthKey(); }
      window.showThemePage = function() { showPage("pageTheme"); }
      window.showPreferencesPage = function() { showPage("pagePreferences"); }
      window.showVipPage = function() { showPage("pageVip"); }
      window.showContactPage = function() { showPage("pageContact"); }
      
      /* ---------- Theme Functions ---------- */
      let deviceThemeListenerAdded = false;
      window.saveTheme = function() {
        const selected = document.querySelector('input[name="theme"]:checked');
        if (selected) {
          localStorage.setItem("theme", selected.value);
          applyTheme();
          showSecurityPage();
        } else {
          alert("Please select a theme.");
        }
      }
      function applyTheme() {
        const theme = localStorage.getItem("theme") || "dark";
        document.body.classList.remove("light-theme", "dark-theme");
        if (theme === "device") {
          if (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches) {
            document.body.classList.add("dark-theme");
          } else {
            document.body.classList.add("light-theme");
          }
          if (!deviceThemeListenerAdded && window.matchMedia) {
            const darkQuery = window.matchMedia("(prefers-color-scheme: dark)");
            darkQuery.addEventListener("change", e => { if (localStorage.getItem("theme") === "device") { applyTheme(); } });
            deviceThemeListenerAdded = true;
          }
        } else if (theme === "dark") {
          document.body.classList.add("dark-theme");
        } else if (theme === "light") {
          document.body.classList.add("light-theme");
        }
      }
      applyTheme();
      
      /* ---------- 2FA Setup Functions (TOTP Verification) ---------- */
      function generateTOTPSecret() {
        const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
        let secret = "";
        for (let i = 0; i < 16; i++) {
          secret += alphabet.charAt(Math.floor(Math.random() * alphabet.length));
        }
        return secret;
      }
      function getAuthKey() {
        if (localStorage.getItem("totpSecret")) {
          return localStorage.getItem("totpSecret");
        } else {
          const key = generateTOTPSecret();
          localStorage.setItem("totpSecret", key);
          return key;
        }
      }
      function loadAuthKey() {
        const key = getAuthKey();
        document.getElementById("authKey").value = key;
        const otpauth = `otpauth://totp/MyApp:${encodeURIComponent(userData.email)}?secret=${key}&issuer=MyApp`;
        const qrURL = `https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=${encodeURIComponent(otpauth)}`;
        document.getElementById("authQR").src = qrURL;
      }
      window.copyAuthKey = function() {
        const keyField = document.getElementById("authKey");
        keyField.select();
        keyField.setSelectionRange(0, 99999);
        document.execCommand("copy");
        alert("Authentication key copied to clipboard!");
        setTimeout(() => { showPage("pageTOTPVerification"); }, 500);
      }
      window.verifyTOTPCode = function() {
        const userCode = document.getElementById("totpCodeInput").value.trim();
        if (userCode === "") { alert("Please enter the verification code."); return; }
        const secret = getAuthKey();
        const totp = new jsOTP.totp();
        const currentTime = Math.floor(Date.now() / 1000);
        const timeStep = 30;
        const validCodes = [
          totp.getOtp(secret, currentTime - timeStep),
          totp.getOtp(secret, currentTime),
          totp.getOtp(secret, currentTime + timeStep)
        ];
        if (validCodes.includes(userCode)) {
          alert("2FA verification successful!");
          setTimeout(() => { showSecurityPage(); }, 3000);
        } else {
          alert("Incorrect code. Please try again.");
        }
      }
      // Manual input verification for when 6 digits are typed
      var totpInput = document.getElementById("totpCodeInput");
      if (totpInput) {
        totpInput.addEventListener("input", function() {
          if (this.value.length === 6) {
            verifyTOTPCode();
          }
        });
      }
      
      /* ---------- Paste Code Button Functionality ---------- */
      var pasteButton = document.getElementById("pasteButton");
      if (pasteButton) {
        pasteButton.addEventListener("click", function() {
          if(navigator.clipboard) {
            navigator.permissions.query({ name: "clipboard-read" }).then(permissionStatus => {
              if (permissionStatus.state === "granted" || permissionStatus.state === "prompt") {
                return navigator.clipboard.readText();
              } else {
                throw new Error("Clipboard read permission denied.");
              }
            }).then(text => {
              let code = text.trim();
              if(code.length === 6 && /^\d{6}$/.test(code)) {
                document.getElementById("totpCodeInput").value = code;
                verifyTOTPCode();
              } else {
                alert("Clipboard does not contain a valid 6-digit code.");
              }
            }).catch(err => {
              console.error("Clipboard read failed:", err);
              alert("Clipboard access is not available. Please enter the code manually.");
            });
          } else {
            alert("Clipboard access is not supported in this browser. Please enter the code manually.");
          }
        });
      }
      
      /* ---------- Pay PIN Functionality ---------- */
      window.authenticatePin = function() {
        const pin = document.getElementById("payPin").value.trim();
        if (!/^\d{6}$/.test(pin)) { alert("Please enter a valid 6-digit PIN."); return; }
        localStorage.setItem("payPin", pin);
        alert("PIN successfully set!");
        setTimeout(() => { showSecurityPage(); }, 3000);
      }
      
      /* ---------- Profile Update Function ---------- */
      window.updateProfile = function() {
        alert("Your profile has been updated successfully.");
      }
      
      /* ---------- Contact/Need Help Page ---------- */
      // The advanced "Need Help?" page uses buttons to redirect to support channels.
      
      /* ---------- WebAuthn Functions for Device Lock ---------- */
      function arrayBufferToBase64(buffer) {
        let binary = "";
        const bytes = new Uint8Array(buffer);
        for (let i = 0; i < bytes.byteLength; i++) {
          binary += String.fromCharCode(bytes[i]);
        }
        return window.btoa(binary);
      }
      function base64ToArrayBuffer(base64) {
        const binary = window.atob(base64);
        const bytes = new Uint8Array(binary.length);
        for (let i = 0; i < binary.length; i++) {
          bytes[i] = binary.charCodeAt(i);
        }
        return bytes.buffer;
      }
      window.registerCredential = async function() {
        if (!window.isSecureContext) { alert("Registration requires HTTPS or localhost."); return; }
        if (!window.PublicKeyCredential) { alert("WebAuthn is not supported on this device."); return; }
        const challenge = new Uint8Array(32);
        window.crypto.getRandomValues(challenge);
        const publicKeyCredentialCreationOptions = {
          challenge: challenge,
          rp: { name: "MyApp" },
          user: {
            id: Uint8Array.from(userData.uid, c => c.charCodeAt(0)),
            name: userData.email,
            displayName: userData.name
          },
          pubKeyCredParams: [{ type: "public-key", alg: -7 }],
          authenticatorSelection: {
            authenticatorAttachment: "platform",
            userVerification: "required"
          },
          timeout: 60000,
          attestation: "none"
        };
        try {
          const credential = await navigator.credentials.create({ publicKey: publicKeyCredentialCreationOptions });
          const credIdBase64 = arrayBufferToBase64(credential.rawId);
          localStorage.setItem("credentialId", credIdBase64);
          alert("Registration successful! Your device is now registered for biometric authentication.");
        } catch (err) {
          alert("Registration failed: " + err.message);
        }
      }
      window.enableDeviceLock = async function() {
        if (!window.isSecureContext) { alert("Device lock requires HTTPS or localhost."); return; }
        if (!window.PublicKeyCredential) { alert("WebAuthn is not supported on this device."); return; }
        const storedCredentialId = localStorage.getItem("credentialId");
        if (!storedCredentialId) { alert("No registered credential found. Please register your device first."); return; }
        try {
          const challenge = new Uint8Array(32);
          window.crypto.getRandomValues(challenge);
          const publicKeyCredentialRequestOptions = {
            challenge: challenge,
            timeout: 60000,
            userVerification: "required",
            allowCredentials: [{
              type: "public-key",
              id: new Uint8Array(base64ToArrayBuffer(storedCredentialId))
            }]
          };
          await navigator.credentials.get({ publicKey: publicKeyCredentialRequestOptions });
          alert("Device lock enabled using biometric authentication!");
        } catch (err) {
          alert("Device authentication failed: " + err.message);
        }
      }
      
      /* ---------- Device Lock Timer ---------- */
      let lockTimer;
      const deviceLockElem = document.getElementById("deviceLockTimer");
      if (deviceLockElem) {
        deviceLockElem.addEventListener("change", function () {
          clearTimeout(lockTimer);
        });
      }
      document.addEventListener("visibilitychange", function () {
        if (document.hidden) {
          const timerInSeconds = parseInt(document.getElementById("deviceLockTimer").value, 10);
          if (timerInSeconds === 0) { enableDeviceLock(); }
          else { lockTimer = setTimeout(enableDeviceLock, timerInSeconds * 1000); }
        } else {
          clearTimeout(lockTimer);
        }
      });
      
      /* ---------- Show Default Page ---------- */
      showAccountInfoPage();
    });
  </script>
</body>
</html>
