namespace DefaultPublisher;

using Microsoft.Sales.Customer;

pagecustomization "My Agent Customer List" customizes "Customer List"
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
        modify("No.")
        {
            Visible = true;
        }
        modify(Name)
        {
            Visible = true;
        }
    }

    // actions
    // {
    // }
}
