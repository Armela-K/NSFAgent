pageextension 50107 NSFonAR extends 9077
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        Addafter("Sales Return Orders")
        {
            action("NSF Agent ")
            {
                ApplicationArea = All;
                Caption = 'Process NSF';
                //Image = ;

                ToolTip = 'Process a returned check as Non-Sufficient Funds';
                RunObject = Page "NSF Check Processing";

            }
        }
    }

    var
        myInt: Integer;
}