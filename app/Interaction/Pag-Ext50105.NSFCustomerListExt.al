namespace DefaultPublisher;

using System.Agents;
using Microsoft.Sales.Customer;

pageextension 50105 "NSF Customer List Ext" extends "Customer List"
{
    actions
    {
        addafter("Co&mments")
        {
            action(ProcessNSFCheck)
            {
                Caption = 'Process NSF Check';
                Image = Action;
                Promoted = true;
                ApplicationArea = All;
                PromotedCategory = Process;
                ToolTip = 'Process a returned check as Non-Sufficient Funds';

                trigger OnAction()
                var
                    NSFCheckProcessing: Page "NSF Check Processing";
                begin
                    NSFCheckProcessing.RunModal();
                end;
            }
        }
    }
}
