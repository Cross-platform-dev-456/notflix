# Notflix Documentation Website

This directory contains the Hugo static site generator configuration and content for the Notflix project documentation website.

## Structure

- `config.yaml` - Hugo configuration file
- `content/` - Markdown content files
  - `_index.md` - Homepage
  - `docs/` - Documentation sections
    - `architecture/` - Architecture documentation
    - `user-manual/` - User tutorial
    - `progress/` - Progress tracking
    - `reports/` - Sprint reports
- `static/` - Static assets (images, etc.)
- `themes/` - Hugo themes (PaperMod is cloned by CI)

## Local Development

To run the site locally:

1. Install Hugo (extended version):
   ```bash
   # macOS
   brew install hugo
   
   # Windows (using Chocolatey)
   choco install hugo-extended
   ```

2. Clone the PaperMod theme:
   ```bash
   cd DOCS/website
   git clone https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod --depth=1
   ```

3. Run the development server:
   ```bash
   hugo server
   ```

4. Open http://localhost:1313 in your browser

## Deployment

The site is automatically deployed to GitHub Pages via GitHub Actions when changes are pushed to the `main` branch.

The workflow:
1. Checks out the repository
2. Sets up Hugo
3. Clones the PaperMod theme
4. Builds the site
5. Deploys to GitHub Pages

## Base URL

The site is deployed at: `https://Cross-platform-dev-456.github.io/notflix/`

Make sure the `baseURL` in `config.yaml` matches this URL.

