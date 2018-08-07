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
                name: $name,
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
    mutation editAccount($id: Int!, $name: String, $accountTypeId: Int) {
        updateAccountById (input: {
            id: $id
            accountPatch: {
                name: $name
                accountTypeId: $accountTypeId
            }
        }) {
            account {
                id
                name
                accountTypeByAccountTypeId {
                    id
                    name
                }
            }
        }
    }
`


