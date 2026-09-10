# Business Central Agent Template

This template provides a complete foundation for building AI-powered agents in Microsoft Dynamics 365 Business Central. It includes all necessary components, interfaces, and boilerplate code to get you started quickly with agent development.

## What You Have

Your agent project includes:
- **Agent metadata and factory** - Defines your agent's identity and behavior
- **Task execution logic** - Processes tasks assigned to your agent
- **Setup infrastructure** - Configuration tables and pages for agent settings
- **Public API** - Ready-to-use codeunit for creating and managing agents
- **KPI tracking** - Monitor your agent's performance
- **Installation and upgrade handlers** - Automatic setup and updates

## Quick Start

### Step 1: Define Your Agent's instructions

Edit **InstructionsV1.txt** in the `.resources/Instructions` folder to provide clear instructions for your agent. This is the most important step as it determines how your agent will behave. 

Alternatively, add custom logic for how instructions should be retrieved per agent via `MyAgentSetup.Codeunit.al`.

### Step 2: Customize Key Components

Search for `TODO:` in your workspace to find all the TODOs. Fill in, based on your agent's implementation.

### Step 3: Try your agent

Publish the app and go to the role center to create an agent. Assign tasks via the Customer Card page extension.

### Step 4: Integrate the agent with Business Central

Add custom logic for invoking your agent via UI interactions, background jobs etc.

### Public API for your agent

If you want your agent to interact with other AL applications, you need to provide a public API for it. The agent API only allows creating, configuring and assigning tasks to agents defined in the same app. An example is provided in the `MyAgentPublicAPI.codeunit.al`.


## What Happens When You Publish

When you publish and install your agent app, the following components become available in Business Central:

- **Agent Registration** - Your agent is automatically registered in the system and a create icon appears on the role center
- **Setup Page** - Users can access the agent setup page to configure settings and activate the agent
- **Public API** - The `My Agent` codeunit provides methods for creating agents, assigning tasks, and managing agent lifecycle
- **Task Integration** - The Customer Card page extension demonstrates how to integrate agent tasks into your business processes
- **Automatic Setup** - Installation codeunits handle initial configuration and data setup
- **Copilot Integration** - Your agent becomes available as a Copilot capability in the Business Central UI

After installation, users with appropriate permissions can activate and configure the agent through the setup page.

## Deployment
To make your agent available, publish and install the app.

## Creating your first agent via the UI

Navigate to Business Central and the role center. See that a new avatar exists for your agent with a '+' icon. Click it to open the setup page where you can setup your first agent.

## Troubleshooting

### Agent does not appear in the UI
Ensure your user has enough permissions to see and manage agents. This requires the `Agent - Admin` or the `SUPER` permission set.

### Agent cannot be activated via install/upgrade
By design, agents need to be activated through a UI interaction. Include activation logic in your setup page or as part of an action.


## Next Steps

1. **Customize the template** - Search for `TODO:` and implement your business logic
2. **Write agent instructions** - Create detailed instructions in `.resources/Instructions/InstructionsV1.txt`
3. **Test your agent** - Create test scenarios and validate agent responses
4. **Deploy to production** - Once tested, deploy to your production environment
5. **Monitor and iterate** - Use KPIs and user feedback to improve agent performance

## Project Structure

```
agent/
├── .resources/                                 # Resource files (e.g., InstructionsV1.txt)
│   └── Instructions/
│       └── InstructionsV1.txt                  # Agent instructions
├── app/
│   ├── Example/
│   │   ├── MyAgentCustomerCardExt.PageExt.al   # Example customer card extension
│   │   └── MyAgentPublicAPI.Codeunit.al        # Public API for agent operations
│   ├── Integration/
│   │   ├── MyAgentCopilotCapability.EnumExt.al # Copilot capability registration
│   │   ├── MyAgentInstall.Codeunit.al          # Installation logic
│   │   └── MyAgentUpgrade.Codeunit.al          # Upgrade logic
│   └── Setup/
│       ├── MyAgentSetup.Codeunit.al            # Agent setup utilities
│       ├── MyAgentSetup.Page.al                # Setup page
│       ├── MyAgentSetup.Table.al               # Setup configuration table
│       ├── KPI/
│       │   ├── MyAgentKPI.Page.al              # Agent summary/dashboard
│       │   └── MyAgentKPI.Table.al             # KPI tracking table
│       ├── Metadata/
│       │   ├── MyAgentFactory.Codeunit.al      # Agent factory implementation
│       │   ├── MyAgentMetadata.Codeunit.al     # Agent metadata provider
│       │   └── MyAgentMetadataProvider.EnumExt.al # Agent metadata provider enum extension
│       ├── Permissions/
│       │   └── MyAgent.permissionset.al        # Agent permission set (includes D365 BASIC)
│       ├── Profile/
│       │   ├── MyAgentCustomerList.PageCustomization.al # Page customization
│       │   ├── MyAgentProfile.Profile.al       # Agent profile
│       │   └── MyAgentRoleCenter.Page.al       # Agent role center
│       └── TaskExecution/
│           └── MyAgentTaskExecution.Codeunit.al # Task execution logic
├── app.json                                    # Project manifest
└── README.md                                   # Readme for the template
```

### Example Integration

`MyAgentCustomerCardExt.PageExt.al` demonstrates how to integrate agent task assignment into your application. It extends the Customer Card page with an action that assigns tasks to an agent based on the current customer record. The page extension shows how to:
- Open the agent lookup to select an agent
- Create a task with customer-specific context
- Provide feedback to the user about the assigned task

`MyAgentPublicAPI.Codeunit.al` provides the public API for creating agents, assigning tasks with external IDs and attachments, and managing agent lifecycle.

## Support

For issues or questions about agent development:
- Report issues in the [BCApps repository](https://github.com/microsoft/BCApps)
- Report issues with the project template in the [AL Language repository](https://github.com/microsoft/al)
