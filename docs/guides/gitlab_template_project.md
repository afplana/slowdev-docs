# Creating a Configuration Project for GitLab Templates & CI/CD

## Introduction

A configuration project for GitLab streamlines and centralizes development workflows, ensuring consistency across projects. This guide will walk you through setting up a project specifically designed for storing GitLab merge request templates and CI/CD configurations.

## Table of Contents

- Why Create a Configuration Project?
- Setting Up The Project
- Adding Merge Request Templates
- Creating CI/CD Templates
- Usage & Implementation
- Best Practices

## Why Create a Configuration Project?

- Standardization: Ensures all teams follow the same templates, providing consistency.
- Efficiency: Reduces duplication by centralizing configurations.
- Maintainability: Having a central location makes it easier to update and maintain templates.

## Setting Up The Project

1. Create a New Repository:
   - Navigate to GitLab and create a new project.
   - Name it something descriptive, like `gitlab-templates` or `gitlab-configurations`.
2. Directory Structure
   - `.gitlab/`: For GitLab-specific configurations.
   - `ci-cd-templates/`: For CI/CD templates to be included in various projects.

## Adding Merge Request Templates

1. Create the Templates Directory:
   - Under `.gitlab/`, create a directory named `merge_request_templates/`.
2. Add Templates:
   - Within the `merge_request_templates/` directory, create markdown files for your templates, e.g., `feature_request.md`, `bug_fix.md`.
3. Populate the Templates:
   - Add sections like `Background`, `Problem`, `Goal`, etc. Use descriptive emojis or headers for clarity.

## Creating CI/CD Templates

1. CI/CD Directory:
   - Ensure you have a `ci-cd-templates/` directory at the root.
2. Populate with Templates:
   - Create YAML files for different CI/CD configurations, like `build.yml` or `deploy.yml`. These templates should include various stages, jobs, and scripts you commonly use across projects.
3. Include Descriptions:
   - At the top of each template, add comments describing its purpose and usage.

## Usage & Implementation

1. Merge Requests:
   - When creating a merge request in any project, select the desired template from a dropdown menu.
2. CI/CD Templates:
   - In any project's `gitlab-ci.yml` file, include the template from your configuration project:

```yml
include:
  - project: '<organization>/<group>/<team>/template'
    file: 'ci-cd-templates/build.yml'
```
