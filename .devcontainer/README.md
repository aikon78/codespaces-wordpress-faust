# Dev Container Configuration for Faust.js + WordPress

This directory contains the configuration for GitHub Codespaces and VS Code Dev Containers.

## What's Included

- **Node.js LTS**: Configured to match the project's `.nvmrc` requirements
- **VS Code Extensions**: Pre-installed extensions for JavaScript, React, Next.js, and GraphQL development
- **Port Forwarding**: Port 3000 is automatically forwarded for the Faust.js development server
- **Automatic Setup**: Dependencies are automatically installed when the container is created

## Getting Started

### Using GitHub Codespaces

1. Click the "Code" button on the repository
2. Select "Codespaces" tab
3. Click "Create codespace on main" (or your branch)
4. Wait for the container to build and initialize
5. Run `npm run dev` to start the development server

### Using VS Code Dev Containers

1. Install the "Dev Containers" extension in VS Code
2. Open the repository in VS Code
3. Press F1 and select "Dev Containers: Reopen in Container"
4. Wait for the container to build and initialize
5. Run `npm run dev` to start the development server

## Environment Variables

Don't forget to set up your environment variables! Copy `.env.local.sample` to `.env.local` and configure:

- `NEXT_PUBLIC_WORDPRESS_URL`: Your WordPress site URL
- `FAUST_SECRET_KEY`: Plugin secret from WordPress Settings->Headless
- `NEXT_PUBLIC_SITE_URL`: Your site URL (use the forwarded port URL in Codespaces)

## Available Commands

- `npm run dev` - Start the development server
- `npm run build` - Build for production
- `npm run start` - Start the production server
- `npm run generate` - Generate GraphQL possible types
- `npm run format` - Format code with Prettier
