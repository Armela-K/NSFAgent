namespace DefaultPublisher;

using System.Agents;

page 50104 "NSF Check Processing"
{
    PageType = StandardDialog;
    Caption = 'Process Non-Sufficient Funds Check';


    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Check Information';
                InstructionalText = 'I am the NSF Agent. Please Enter Customer and Check Number that was returned.';

                field(CustomerNameOrNumber; CustomerNameOrNumber)
                {
                    Caption = 'Enter Customer Name or Number and check number.';
                    ApplicationArea = all;
                    ToolTip = 'Enter Customer Name or Number and check number.';
                    MultiLine = true;
                }

                // field(CheckNumber; CheckNumber)
                // {
                //      Caption = 'Check Number';
                //      ApplicationArea = all;
                //      ToolTip = 'Enter the returned check number';
                //  }
            }
        }
    }

    actions
    {
    }

    var
        CustomerNameOrNumber: Text[400];
    //   CheckNumber: Text[50];

    trigger OnQueryClosePage(CloseAction: Action): Boolean


    begin
        if CloseAction = Action::OK then
            ProcessNSFCheckWithConfirmation();
    end;

    local procedure ProcessNSFCheckWithConfirmation(): Boolean
    var
        NSFAgentPublicAPI: Codeunit "NSF Agent Public API";
        AgentUserSecurityID: Guid;
        Message: Text;
        ConfirmationMsg: Text;
        NSFSetup: codeunit "NSF Agent Setup";
        agent: codeunit "Agent";
        AgentTaskBuilder: Codeunit "Agent Task Builder";
        AgentTask: Record "Agent Task";
        AgentTaskMessageBuilder: Codeunit "Agent Task Message Builder";

    begin
        // Validate inputs
        if CustomerNameOrNumber = '' then begin
            Error('Customer name or number is required.');
        end;

        // if CheckNumber = '' then begin
        // Error('Check number is required.');
        //end;

        if not NSFSetup.TryGetAgent(AgentUserSecurityId) then begin
            // Auto-create the agent if it doesn't exist
            AgentUserSecurityId := CreateAndActivateAgent();
        end;

        if not Agent.IsActive(AgentUserSecurityId) then
            Error('Agent is not active.');
        // Show confirmation to user
        // ConfirmationMsg := StrSubstNo(
        //    'Are you sure you want to process the NSF check?\Customer: %1\Check Number: %2\This will create an NSF transaction, void the payment, and unapply related customer ledger entries.',
        //    CustomerNameOrNumber,
        //    CheckNumber);

        // if not Confirm(ConfirmationMsg) then
        //     exit(false);



        // Build the message for the agent
        // Message := StrSubstNo(
        //   'Customer Name: %1, Check Number: %2',
        //   CustomerNameOrNumber,
        //   CheckNumber);
        Message := StrSubstNo(
           'Customer: %1',
           CustomerNameOrNumber);
        // CheckNumber);

        // Assign the task to the agent (prior version)
        // NSFAgentPublicAPI.AssignTask(
        //   AgentUserSecurityID,
        //   'NSF Check Processing',
        //  UserId(),
        //  Message);




        //SO validation
        // AgentTask := AgentTaskBuilder.Initialize(AgentUserSecurityId, 'NSF Check Processing')
        //      .AddTaskMessage(userid(), Message)
        //         .Create();

        //     Message(TaskAssignedMsg, AgentTask.ID, ShipmentDate);

        //MS Suggestion.

        AgentTaskMessageBuilder
        .Initialize('System', message)
        .SetRequiresReview(false);


        AgentTask := AgentTaskBuilder
            .Initialize(AgentUserSecurityId, 'Review NSF')
            .AddTaskMessage(AgentTaskMessageBuilder)
            .Create();
        Message('NSF processing task has been created and assigned to the agent');
        //. Task will process the NSF transaction for Check Number: %1', CheckNumber));

        exit(true);
    end;

    local procedure CreateAndActivateAgent(): Guid
    var
        AgentSetupBuffer: Record "Agent Setup Buffer";
        NSFSetupCU: Codeunit "NSF Agent Setup";
        AgentSetupCU: Codeunit "Agent Setup";
        AgentCU: Codeunit Agent;
        NSFAgentSetupRec: Record "NSF Agent Setup";
        NewAgentUserSecurityId: Guid;
    begin
        NewAgentUserSecurityId := CreateGuid();

        // Initialize the agent setup with default values
        AgentSetupCU.GetSetupRecord(
            AgentSetupBuffer,
            NewAgentUserSecurityId,
            Enum::"Agent Metadata Provider"::"My Agent",
            'NSF Agent - ' + CompanyName(),
            'NSF Agent',
            'Non-Sufficient Funds Check Processing Agent');

        // Enable the agent
        //AgentSetupBuffer.Enabled := true;

        // Save the agent to the system
        NewAgentUserSecurityId := AgentSetupCU.SaveChanges(AgentSetupBuffer);

        // Set the instructions
        AgentCU.SetInstructions(NewAgentUserSecurityId, NSFSetupCU.GetInstructions());

        // Save the setup record to NSF Agent Setup table (non-temporary)
        NSFAgentSetupRec.Init();
        NSFAgentSetupRec."User Security ID" := NewAgentUserSecurityId;
        if NSFAgentSetupRec.Insert() then
            Message('NSF Agent has been automatically created and activated.')
        else
            Error('Failed to save NSF Agent configuration.');

        exit(NewAgentUserSecurityId);
    end;

    local procedure GetAgentUserSecurityID(): Guid
    var
        AgentSetupBuffer: Record "Agent Setup Buffer";
    begin
        // Query the agent setup to get the user security ID
        if AgentSetupBuffer.FindFirst() then
            exit(AgentSetupBuffer."User Security ID");

        Error('NSF Agent is not configured. Please set up the agent first.');
    end;
}
