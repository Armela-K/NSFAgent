namespace DefaultPublisher;

using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;

pagecustomization "My Agent CusLedg" customizes "Customer Ledger Entries"
{
    // Clear page and add only the relevant components for My Agent profile
    // ClearActions = true;
    // ClearLayout = true;
    // ClearViews = true;

    ClearLayout = true;
    ClearActions = true;

    // TODO: Add the components that the agent should be able to see and interact with
    layout
    {
        modify("Document No.")
        {
            Visible = true;
        }
        modify("Customer No.")
        {
            Visible = true;
        }
        modify("Customer Name")
        {
            Visible = true;
        }
    }

    actions
    {
        modify(INARCreateNonSufficientFundsAction)
        {
            Visible = true;
        }
    }
}
