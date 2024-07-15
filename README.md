# GitHub App Integration with Sinatra and Octokit

## Overview

This project demonstrates how to integrate a GitHub App with a Sinatra application using the Octokit gem. The GitHub App interacts with GitHub repositories by commenting on newly opened issues that lack specific content.

## Prerequisites

Before you begin, ensure you have the following installed:

- Ruby (version 3.1.2 recommended)
- Bundler gem (`gem install bundler`)
- GitHub Developer account with a registered GitHub App

## Setup Instructions

### 1. Clone the Repository

git clone <repository-url>
cd <repository-directory>

## Install Dependencies
bundle install

## Configure Environment Variables
Create a .env file in the root directory with the following variables:

GITHUB_PRIVATE_KEY=<your GitHub App's private key>
GITHUB_APP_IDENTIFIER=<your GitHub App's identifier>
Replace <your GitHub App's private key> and <your GitHub App's identifier> with your actual GitHub App's private key and identifier.

##  Start the Sinatra Application

ruby app.rb 
This will start the Sinatra application on http://localhost:4567.

## Forward Events Using Smee.io
Install the Smee.io client:
npm install --global smee-client

Go to the https://smee.io/ to start the new channel.
Run the Smee.io client to forward the events to your local server:


smee -u https://smee.io/<YOUR Webhook Proxy URL> --target http://localhost:4567/payload

## Configure Your GitHub App
Install Your GitHub App:

Go to your GitHub account Settings > Developer settings > GitHub Apps.
Install your GitHub App on the desired repositories.
Setup Webhook:

Navigate to the repository where you installed the GitHub App.
Go to Settings > Webhooks > Add webhook.
Set the Payload URL to http://your-server-url:4567/payload (replace your-server-url with your actual server URL).
Choose "Let me select individual events" and select Issues events (ex: Issues, Comment Issues) 

## Testing
Create a New GitHub Repository:
Create a new repository on GitHub to test your webhook setup.
Set Up Webhook for the New Repository:
Follow the steps above to add a webhook for your newly created repository.
Trigger a Test Event:
Perform an action that triggers the webhook event you configured (e.g., open a new issue).
Verify Webhook Handling:
Check your Sinatra application logs to ensure it correctly receives and processes the webhook payload from GitHub via Smee.io.

Estimate Detection: Your app should analyze the body of the newly created issue and check if it contains an estimate in the format "Estimate: X days" (e.g., "Estimate: 2 days").