public class AccountData {
   
    public List<Monthly_Financial_Account_Data__c> createNewFinincial(String dateId){
         // add the latest date to the balances latest date
        List<Monthly_Financial_Account_Data__c> subList = new List<Monthly_Financial_Account_Data__c>();
        if(financialAccountDataList != null && !financialAccountDataList.isEmpty()){
            for(Monthly_Financial_Account_Data__c monthlyAcount : financialAccountDataList) {
                Monthly_Financial_Account_Data__c financialAccount;
                financialAccount = new Monthly_Financial_Account_Data__c();
                financialAccount.User_Updated__c = false;
                financialAccount.Copy_Forward__c = true;
                financialAccount.Previous_Month__c = monthlyAcount.Id;
                financialAccount.Current_Balance__c = monthlyAcount.Current_Balance__c;
                financialAccount.Financial_Accounts__c = monthlyAcount.Financial_Accounts__r.Id;
                financialAccount.Interest_Rate__c = monthlyAcount.Interest_Rate__c;
                financialAccount.CC_Limit_Orig_Loan_Amt__c = monthlyAcount.CC_Limit_Orig_Loan_Amt__c;
                financialAccount.Date__c = dateId;
                financialAccount.Name = monthlyAcount.Name;
                financialAccount.Subtype__c = monthlyAcount.Subtype__c;
                financialAccount.Productive_Debt__c = monthlyAcount.Productive_Debt__c;
                financialAccount.Urgent_Debt__c = monthlyAcount.Urgent_Debt__c;
                financialAccount.Collections_Charge_offs__c = monthlyAcount.Collections_Charge_offs__c;
                financialAccount.RecordTypeId = monthlyAcount.RecordTypeId;
                financialAccount.Record_Type_Name__c = monthlyAcount.Record_Type_Name__c;
                financialAccount.Monthly_Minimum_Payment__c = monthlyAcount.Monthly_Minimum_Payment__c;
                financialAccount.Deposits__c = null;
                subList.add(financialAccount);
            }
        }
       return subList;
    }

    public List<Monthly_Budget_Data__c> createNewBudgetFinincial(String dateId){
        // add the latest date to the balances latest date
        List<Monthly_Budget_Data__c> subList = new List<Monthly_Budget_Data__c>();
        if(budgetDataList != null && !budgetDataList.isEmpty()){
            for(Monthly_Budget_Data__c monthlyBudget : budgetDataList) {
                if(monthlyBudget.Income_Frequency__c != "One-Time/Non-Recurring") {
                    Monthly_Budget_Data__c budgetAccount;
                    budgetAccount = new Monthly_Budget_Data__c();
                    budgetAccount.Budgets__c = monthlyBudget.Budgets__r.Id;
                    budgetAccount.User_Updated__c = false;
                    budgetAccount.Previous_Month__c = monthlyBudget.Id;
                    budgetAccount.Copy_Forward__c = true;
                    budgetAccount.Gross_Amount__c = monthlyBudget.Gross_Amount__c;
                    budgetAccount.Monthly_Actual_Amount__c = monthlyBudget.Monthly_Actual_Amount__c;
                    budgetAccount.RecordTypeId = monthlyBudget.RecordTypeId;
                    budgetAccount.Name = monthlyBudget.Name;
                    budgetAccount.Savings_Goal_Due_Date__c = monthlyBudget.Savings_Goal_Due_Date__c;
                    budgetAccount.Date__c = dateId;
                    budgetAccount.Take_Home_Amount__c = monthlyBudget.Take_Home_Amount__c;
                    budgetAccount.Income_Frequency__c = monthlyBudget.Income_Frequency__c;
                    budgetAccount.Monthly_Expected_Amount__c = monthlyBudget.Monthly_Expected_Amount__c;
                    budgetAccount.Record_Type_Name__c = monthlyBudget.Record_Type_Name__c;
                    budgetAccount.Savings_Goal_Amount__c = monthlyBudget.Savings_Goal_Amount__c;
                    budgetAccount.Total_Amount_Saved_for_Goal__c = monthlyBudget.Total_Amount_Saved_for_Goal__c;
                    budgetAccount.Target_Monthly_Savings__c = monthlyBudget.Target_Monthly_Savings__c;
                    subList.add(budgetAccount);
                }
            }
        }
        return subList;
    }
   
}

