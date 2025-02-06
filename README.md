# Formatho

A macOS/iOS app ecosystem for Azure DevOps work item tracking and visualization.

## Features

- **Work Item Type (WIT) Management**
  - View and manage different work item types
  - Detailed WIT information display
  - Recent activity tracking

- **Query Management**
  - Custom query support
  - Query hierarchy view
  - Work item table view for query results

- **Visualization**
  - Graph view for work item relationships
  - Tree view for hierarchical representation
  - List view for simplified item display

- **Cross-Platform**
  - Native iOS app
  - macOS widget support
  - Synchronized settings across devices via App Groups

- **Settings & Configuration**
  - Azure DevOps organization integration
  - Personal Access Token (PAT) authentication
  - Project-specific settings
  - Clipboard integration options
  - Report generation features

## Project Structure

```
Formatho/
├── Formatho/            # Main iOS app
│   ├── Views/          # UI components
│   ├── Common/         # Shared utilities
│   ├── DetailViews/    # Detailed UI views
│   └── Subs/          # Subscription handling
├── Formatho.xcodeproj/ # Xcode project files
├── formathoIntent/     # Intent handling
├── formathoPhone/      # iPhone specific code
└── macWidget/         # macOS widget implementation
```

## Requirements

- Xcode 14.0+
- iOS 16.0+
- macOS 12.0+
- Azure DevOps account with appropriate permissions
- Personal Access Token (PAT) with work item read permissions

## Getting Started

1. Clone the repository
2. Open `Formatho.xcodeproj` in Xcode
3. Configure your Azure DevOps credentials in the settings:
   - Organization name
   - Email
   - Personal Access Token (PAT)
   - Project name
4. Build and run the project

## Configuration

The app supports several configuration options:
- Copy to clipboard functionality
- Report inclusion in outputs
- Custom query management
- Widget configurations

[Add your license here]

## Contributing

[Add contribution guidelines]

## Support

[Add your contact information]