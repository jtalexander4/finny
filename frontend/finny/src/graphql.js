import gql from 'graphql-tag'

export const ADD_ACCOUNT_TYPE = gql`
    mutation AddAccountType($name: String!, $credit_positive: Boolean!) {
        createAccountType(input: {
            accountType: {
                name: $name,
                creditPositive: $credit_positive
            }
        }) {
            accountType {
                id
                name
                creditPositive
            }
        }
    }
`

export const ADD_ACCOUNT = gql`
    mutation AddAccount($name: String!, $parentAccountId: Int, $balance: BigFloat!, $accountTypeId: Int!) {
        createAccount( input: {
            account: {
                name: $name
                balance: $balance
                accountTypeId: $accountTypeId
                parentAccountId: $parentAccountId
            }
        }) {
            account {
                name
                balance
                accountTypeByAccountTypeId {
                    id
                    name
                }
                parentAccountId
            }
        }
    }
`

export const EDIT_ACCOUNT = gql`
    mutation editAccount($id: Int!, $name: String, $accountTypeId: Int $parentAccountId: Int) {
        updateAccountById (input: {
            id: $id
            accountPatch: {
                name: $name
                accountTypeId: $accountTypeId
                parentAccountId: $parentAccountId
            }
        }) {
            account {
                id
                name
                accountTypeByAccountTypeId {
                    id
                    name
                }
                accountByParentAccountId {
                    id
                    name
                }
            }
        }
    }
`

export const DELETE_ACCOUNT = gql`
    mutation deleteAccount($id: Int!) {
        deleteAccountById (input: {
            id: $id
        }) {
            account {
                id
                name
            }
        }
    }
`

export const TESTING = gql`
    query ($name: String!) {
        allTestings(filter: {name: {equalTo: $name}}) {
            nodes {
                name
                amount
            }
        }
    }
`

export const ADD_TRANSACTION_LINE = gql`
    mutation AddTransactionLine($accountId: Int!, $amount: BigFloat!, $fiscalPeriodId: Int!, $datePosted: Date!) {
        createTransactionLine( input: {
            transactionLine: {
                accountId: $accountId
                amount: $amount
                fiscalPeriodId: $fiscalPeriodId
                datePosted: $datePosted
            }
        }) {
            transactionLine {
                accountByAccountId {
                    id
                    name
                }
                amount
                fiscalPeriodByFiscalPeriodId {
                    id
                    name
                }
                datePosted
            }
        }
    }
`