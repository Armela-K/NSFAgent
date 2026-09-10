permissionset 50100 "All"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions', Locked = true;

    Permissions =
         codeunit "My Agent Public API Impl." = X,
         codeunit "My Agent Upgrade" = X,
         codeunit MyAgentFactory = X,
         codeunit MyAgentMetadata = X,
         codeunit MyAgentTaskExecution = X,
         codeunit "NSF Agent Install" = X,
         codeunit "NSF Agent Public API" = X,
         codeunit "NSF Agent Setup" = X,
         page "My Agent Role Center" = X,
         page "NSF Agent KPI" = X,
         page "NSF Agent Setup" = X,
         page "NSF Check Processing" = X,
         table "NSF Agent KPI" = X,
         table "NSF Agent Setup" = X,
         tabledata "NSF Agent KPI" = RIMD,
         tabledata "NSF Agent Setup" = RIMD;
}