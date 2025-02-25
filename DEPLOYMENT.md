# Deployment Guide

This document describes how to deploy new versions of videojs-ima to Google Cloud Storage.

## Prerequisites

1. Make sure you have [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
2. Configure `gsutil` authentication
3. Ensure you have access to the `a.pub.network` bucket

## Deployment Steps

1. Build and test your changes locally:
```bash
npm install
npm run test
```

2. Update version in `package.json` if needed

3. Run the publish script:
```bash
npm run publish
```

The publish script will:
- Build minified version of the plugin
- Detect current version from package.json
- **Use branch name as version suffix if not on main branch**
- Upload files to `gs://a.pub.network/core/videojs-ima/<version>/`
- Set public read access on uploaded files

### Version Handling

- On main branch: Uses version from package.json (e.g. "2.2.0")
- On other branches: Appends branch name to version (e.g. "2.2.0-feature-branch")

### Files Deployed

- `videojs.ima.min.js`
- `videojs.ima.css`

### Overwriting Existing Versions

If files already exist at the target version, the script will prompt for confirmation before overwriting.
