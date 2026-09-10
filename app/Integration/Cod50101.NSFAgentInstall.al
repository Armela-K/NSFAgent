namespace DefaultPublisher;

using System.Agents;
using System.AI;
using System.Security.AccessControl;

codeunit 50101 "NSF Agent Install"
{
    Subtype = Install;
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnInstallAppPerDatabase()
    var
        MyAgentSetup: Record "NSF Agent Setup";
    begin
        RegisterCapability();

        if not MyAgentSetup.FindSet() then
            exit;

        repeat
            InstallAgent(MyAgentSetup);
        until MyAgentSetup.Next() = 0;
    end;

    local procedure InstallAgent(var NSFAgentSetup: Record "NSF Agent Setup")
    begin
        InstallAgentInstructions(NSFAgentSetup);
        InstallAccessControl(NSFAgentSetup);
        InstallAgentSetup(NSFAgentSetup);
    end;

    local procedure InstallAgentInstructions(var NSFAgentSetup: Record "NSF Agent Setup")
    var
        Agent: Codeunit Agent;
        MyAgentSetupCU: Codeunit "NSF Agent Setup";
    begin
        Agent.SetInstructions(NSFAgentSetup."User Security ID", MyAgentSetupCU.GetInstructions());
    end;

    local procedure InstallAccessControl(var NSFAgentSetup: Record "NSF Agent Setup")
    var
        Agent: Codeunit Agent;
        TempAgentAccessControl: Record "Access Control Buffer" temporary;
    begin
        // TODO: Override access control install logic if needed
        // Agent.UpdateAccessControl(NSFAgentSetup."User Security ID", TempAgentAccessControl);
    end;

    local procedure InstallAgentSetup(var NSFAgentSetup: Record "NSF Agent Setup")
    begin
        // TODO: Custom install logic for NSF Agent Setup record if needed
    end;

    [EventSubscriber(ObjectType::Page, Page::"Copilot AI Capabilities", 'OnRegisterCopilotCapability', '', false, false)]
    local procedure OnRegisterCopilotCapability()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'link-to-my-documentation', Locked = true; // TODO: Update with actual documentation URL
    begin
        if CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"My Agent Capability") then
            CopilotCapability.UnregisterCapability(Enum::"Copilot Capability"::"My Agent Capability");

        // Register capability
        CopilotCapability.RegisterCapability(
        Enum::"Copilot Capability"::"My Agent Capability",
        Enum::"Copilot Availability"::Preview,
        "Copilot Billing Type"::"Microsoft Billed",
        LearnMoreUrlTxt)
    end;
}