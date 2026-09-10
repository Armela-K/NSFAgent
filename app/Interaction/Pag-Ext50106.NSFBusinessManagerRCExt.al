namespace DefaultPublisher;

pageextension 50106 "NSF Business Manager RC Ext" extends 9022
{
    actions
    {
        addafter("Register Customer Payments")
        {
            action(ProcessNSFCheck)
            {
                Caption = 'Process NSF Check';
                Image = Action;

                ToolTip = 'Process a returned check as Non-Sufficient Funds';
                RunObject = Page "NSF Check Processing";
                ApplicationArea = All;
            }
        }
    }
}
