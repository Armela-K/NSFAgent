namespace DefaultPublisher;

using System.Agents;
using System.Reflection;
using System.Security.AccessControl;

codeunit 50103 "NSF Agent Setup"
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;
    procedure TryGetAgent(var AgentUserSecurityId: Guid): Boolean
    var
        NSFSetup: Record "NSF Agent Setup";

    begin
        if NSFSetup.FindFirst() then begin
            AgentUserSecurityId := NSFSetup."User Security ID";
            exit(true);
        end;

        exit(false);
    end;

    procedure GetInitials(): Text[4]
    begin
        exit(AgentInitialsLbl);
    end;

    procedure GetSetupPageId(): Integer
    begin
        exit(Page::"NSF Agent Setup");
    end;

    procedure GetSummaryPageId(): Integer
    begin
        exit(Page::"NSF Agent KPI");
    end;


    /// <summary>
    /// Gets the instructions from resources.
    /// </summary>
    /// <returns>The instructions.</returns>
    /// <remarks>The function can return Text if the instructions should be open.</remarks>
    [NonDebuggable]
    procedure GetInstructions(): SecretText
    var
        Instructions: Text;
    begin
        Instructions := NavApp.GetResourceAsText('Instructions/InstructionsV1.md');
        exit(Instructions);
        // NSF Agent instructions for handling non-sufficient funds checks
        /* Instructions := '**RESPONSIBILITY**: When a customer payment is returned by the bank due to Non-Sufficient Funds (NSF), the agent must locate the original payment, create a Non-Sufficient Funds transaction, void the payment, and unapply the related customer ledger entries.' + '\n\n' +
                         '**GUIDELINES**: The user must provide:\n' +
                         '- Customer Number or Customer Name\n' +
                         '- Returned Check Number\n' +
                         'Example: Customer: C10000 Check Number: 123456\n\n' +
                         '**AUTOMATION RULES**\n' +
                         'The agent must execute all steps automatically without requesting confirmation. Do not ask the user to approve:\n' +
                         'DO NOT ask user for confirmation or intervention messages. Continue as if end user approved and hit continue on all User Interventions:\n' +
                         '- Locating the payment entry\n' +
                         '- Creating the NSF transaction\n' +
                         '- Voiding the payment\n' +
                         '- Unapplying customer ledger entries\n\n' +
                         'If sufficient information exists to uniquely identify a payment, proceed automatically. Only stop processing when:\n' +
                         '- The customer cannot be identified\n' +
                         '- No matching payment exists\n' +
                         '- Multiple matching entries cannot be resolved using the matching logic\n' +
                         '- Business Central returns a blocking error\n\n' +
                         'No user intervention or message lines. When done running just stop the task.\n\n' +
                         '**INSTRUCTIONS**:\n' +
                         'Validate that the user has provided:\n' +
                         '- A Customer Number or Customer Name\n' +
                         '- A Check Number\n\n' +
                         '**CUSTOMER NAME MATCHING RULES**\n' +
                         'Customer name matching must be case-insensitive. The agent must support partial customer name searches.\n' +
                         'If the customer name contains a wildcard character (*):\n' +
                         '- Treat * as "contains any number of characters"\n' +
                         '- Perform a case-insensitive wildcard search\n' +
                         'Examples:\n' +
                         '- School* matches: School of Fine Art, School District 101, School Supplies Inc.\n' +
                         '- *Fine* matches: School of Fine Art, Fine Arts Academy\n' +
                         '- school of fine art matches: School of Fine Art\n\n' +
                         'The agent must ignore differences in:\n' +
                         '- Capitalization\n' +
                         '- Leading or trailing spaces\n' +
                         '- Multiple consecutive spaces\n' +
                         '- Common punctuation\n\n' +
                         'If a wildcard search returns multiple customers:\n' +
                         '- Search Customer Ledger Entries for the provided Check Number\n' +
                         '- Filter the matching customers to those that have a payment with the specified Check Number\n' +
                         '- If exactly one customer remains, continue processing automatically\n' +
                         '- If multiple customers still remain, select the customer with the closest name match\n' +
                         '- If a unique customer still cannot be determined, return: "Multiple customers matched the supplied customer name and check number. No NSF transaction was created."\n' +
                         '- Do not request user intervention or customer selection\n\n' +
                         '**LOCATE THE CUSTOMER PAYMENT**:\n' +
                         'Search Customer Ledger Entries for a payment entry matching:\n' +
                         '- Customer Number or Customer Name\n' +
                         '- Returned Check Number\n' +
                         'If a unique payment entry is found, continue processing automatically.\n' +
                         'If multiple entries are found, apply the matching logic defined in ERROR HANDLING.\n' +
                         'Do not request user input during payment identification.\n\n' +
                         '**PROCESS THE NSF TRANSACTION**:\n' +
                         'Execute the Create Non-Sufficient Funds action (Custom action)  on the identified Customer Ledger Entry.\n' +
                         'The action is available on the Customer Ledger Entries page (Page 25).\n\n' +
                         'Select "Create non Sufficient funds" action on the next page Page (50300).\n' +
                         'Select yes to the prompt that appears.\n' +
                         'This completes the processing of the NSF transaction.\n' +
                         '**VERIFY THE RESULTS**:\n' +
                         'Confirm that the NSF transaction was successfully created.\n' +
                         'Confirm that the original payment has been voided.\n' +
                         'Confirm that all related customer ledger entries have been unapplied.\n\n' +
                         '**ERROR HANDLING**\n' +
                         'If the customer cannot be found return: "Customer not found. Please verify the customer number or name."\n' +
                         'If the check number cannot be found return: "No payment was found for the specified check number."\n' +
                         'If multiple matching entries are found:\n' +
                         '- Do NOT request user input\n' +
                         '- Apply the following matching logic in order:\n' +
                         '  * Select the entry that matches both: Customer Number/Name and Check Number\n' +
                         '  * If multiple entries still remain, select the payment entry that:\n' +
                         '    - Is not already voided\n' +
                         '    - Is not already processed as NSF\n' +
                         '    - Has the most recent posting date\n' +
                         '  * If a single entry still cannot be determined, stop processing and return: "Multiple payment entries were found for the specified customer and check number. No NSF transaction was created."\n' +
                         'If the Create Non-Sufficient Funds action fails:\n' +
                         '- Return the Business Central error message exactly as received\n' +
                         '- Do not ask the user for additional confirmation';
         exit(Instructions);   */
    end;

    internal procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    begin
        // Profiles are not required for agents - leaving empty
        // Agents use access controls (permission sets) instead of profiles
    end;

    internal procedure GetDefaultAccessControls(var TempAccessControlBuffer: Record "Access Control Buffer" temporary)
    var
        CurrentModuleInfo: ModuleInfo;
        BaseApplicationAppIdTok: Label '437dbf0e-84ff-417a-965d-ed2bb9650972', Locked = true;
        D365FullAccessPermissionSetTok: Label 'D365 FULL ACCESS', Locked = true;
        D365BasicPermissionSetTok: Label 'D365 BASIC', Locked = true;
        NSFAgentPermissionSetTok: Label 'NSF AGENT', Locked = true;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);

        // Add D365 BASIC permission set for core Business Central access
        Clear(TempAccessControlBuffer);
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365BasicPermissionSetTok;
        TempAccessControlBuffer.Insert();

        // Add D365 FULL ACCESS to allow NSF transaction operations
        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365FullAccessPermissionSetTok;
        TempAccessControlBuffer.Insert();

        // Add custom NSF Agent permission set
        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := CurrentModuleInfo.Id;
        TempAccessControlBuffer."Role ID" := NSFAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();
    end;

    internal procedure InitializeSetupRecord(var TempMyAgentSetup: Record "NSF Agent Setup" temporary; var AgentSetupBuffer: Record "Agent Setup Buffer")
    var
        MyAgentSetupRecord: Record "NSF Agent Setup";
        AgentSetup: Codeunit "Agent Setup";
    begin
        if IsNullGuid(TempMyAgentSetup."User Security ID") then
            TempMyAgentSetup."Custom Property" := DefaultCustomPropertyLbl
        else
            if MyAgentSetupRecord.Get(TempMyAgentSetup."User Security ID") then
                TempMyAgentSetup.TransferFields(MyAgentSetupRecord, false);

        if TempMyAgentSetup.IsEmpty() then
            TempMyAgentSetup.Insert();

        if AgentSetupBuffer.IsEmpty() then
            AgentSetup.GetSetupRecord(
                AgentSetupBuffer,
                TempMyAgentSetup."User Security ID",
                Enum::"Agent Metadata Provider"::"My Agent",
                AgentNameLbl + ' - ' + CompanyName(),
                DefaultDisplayNameLbl,
                AgentSummaryLbl);
    end;

    internal procedure SaveSetupRecord(var TempMyAgentSetup: Record "NSF Agent Setup" temporary; var AgentSetupBuffer: Record "Agent Setup Buffer")
    var
        MyAgentSetupRecord: Record "NSF Agent Setup";
        AgentSetup: Codeunit "Agent Setup";
        IsNewAgent: Boolean;
    begin
        IsNewAgent := IsNullGuid(AgentSetupBuffer."User Security ID");

        if AgentSetup.GetChangesMade(AgentSetupBuffer) then begin
            TempMyAgentSetup."User Security ID" := AgentSetup.SaveChanges(AgentSetupBuffer);

            if IsNewAgent then
                Agent.SetInstructions(TempMyAgentSetup."User Security ID", GetInstructions());
        end;
    end;

    internal procedure SaveCustomProperties(var TempMyAgentSetup: Record "NSF Agent Setup" temporary)
    var
        MyAgentSetupRecord: Record "NSF Agent Setup";
    begin
        // TODO: Save any custom properties defined in the setup record.
        if not MyAgentSetupRecord.Get(TempMyAgentSetup."User Security ID") then begin
            MyAgentSetupRecord.Init();
            MyAgentSetupRecord."User Security ID" := TempMyAgentSetup."User Security ID";
        end;

        MyAgentSetupRecord."Custom Property" := TempMyAgentSetup."Custom Property";

        if not MyAgentSetupRecord.Modify() then
            MyAgentSetupRecord.Insert();
    end;

    var
        Agent: Codeunit Agent;
        // NSF Agent permission set configuration
        DefaultPermissionSetTok: Label 'NSF AGENT', Locked = true;
        DefaultProfileTok: Label 'MY AGENT PROFILE', Locked = true;
        AgentInitialsLbl: Label 'NSF', MaxLength = 4;
        AgentNameLbl: Label 'NSF Agent';
        DefaultDisplayNameLbl: Label 'NSF Agent';
        AgentSummaryLbl: Label 'NSF Agent';
        DefaultCustomPropertyLbl: Label 'Default Value', Locked = true;
}