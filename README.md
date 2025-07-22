# ManageMyYoutube

**Software Architecture and IT Security Laboratory Project  
La Sapienza University of Rome, 2021–2022**  
Built with **Ruby** and the **Ruby on Rails** framework

---

## 📘 Overview

This web application enables users to **collaborate and manage YouTube channels** by connecting **clients** (channel owners) with **managers** (advisors/coaches). It allows for analysis, channel support, and integration with YouTube and Google Calendar APIs.

### 👥 Roles & Permissions

- **Guest (unregistered users)**: Can only register as client or manager.
- **Client**:  
  - Can search for managers, view profiles and reviews, and affiliate with one.  
  - Can manage their own YouTube channel via Google APIs.
- **Manager**:  
  - Can analyze data, view client stats, post suggestions or events.  
  - Can accept or remove affiliated clients.

### 🔐 Access Modes

- **Local Access**: Users register and log in with their own credentials.
- **Google OAuth**: Users can log in using a Google account to access **Calendar** and **YouTube APIs** (not for logging into other users' accounts).

---

## 🧾 Managed Data

- **Users**: Account type (client/manager), nickname, email, birthdate, and (if local) password.  
- **Public Profiles**: YouTube channel details (videos, images, descriptions).  
- **Client-Manager Relationships**: Reviews, affiliations, events.  
- **YouTube Data**: Channel and video management via APIs.  
- **Calendar Data**: Schedules and meetings via Google Calendar API.

---

## 🌐 External Integrations

- **Google Calendar API**: Schedule and manage events between clients and managers.
- **YouTube Data API**: Display, upload, and manage channel and video details.

---

## 🚀 User Stories

### 🔸 General

1. **Sign Up**: As a guest, I want to create an account as client or manager.
2. **Login**: As a user, I want to log in and use the platform.
3. **OAuth Login**: As a user, I want to connect with Google and access APIs.
4. **Edit Profile**: As a user, I want to update my personal information and avatar.
5. **Delete Account**: As a user, I want to delete my profile and data.

---

### 🔸 Client

- **Manager Interactions**
  - View manager profiles and public data.
  - Search and filter managers.
  - Affiliate/unaffiliate with a manager.
  - Leave, edit, or delete reviews.

- **YouTube API Features**
  - View channel subscribers, videos, and comments.
  - Upload, update, or delete videos.
  - Modify channel watermark, banner, and description.
  - Manage playlists: create, edit, delete.
  - View video stats and ratings.

---

### 🔸 Manager

- **Client Management**
  - Accept or remove clients.
  - View YouTube activity and channel info of affiliated clients.

- **Calendar API Features**
  - Create, edit, delete events in Google Calendar.
  - View daily schedules.
  - Create or delete client-specific calendars.
  - List all calendars to get an overview of client engagements.

---

## 🛠️ Getting Started

To run this project locally with Docker:

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/your_project.git
   cd your_project
   ```

2. Build and run with Docker:
   ```bash
   docker-compose build
   docker-compose up
   ```

3. Setup database (on first run):
   ```bash
   docker-compose run web rake db:create db:migrate
   ```

4. Access the app at: [http://localhost:3000](http://localhost:3000)
