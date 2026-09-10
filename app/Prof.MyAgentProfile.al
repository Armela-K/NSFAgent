namespace DefaultPublisher;
using Microsoft.Finance.RoleCenters;

profile "My Agent Profile"
{
    Caption = 'NSF Agent';
    Description = 'Profile for NSF Agent handling non-sufficient funds checks';
    // Defines the starting point for the NSF Agent and the views of pages it will see



    RoleCenter = "Acc. Receivables Adm. RC";
    Customizations = "My Agent Customer List", "My Agent CusLedg";
}
