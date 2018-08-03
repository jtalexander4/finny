<template>
    <v-layout row justify-center>
        <v-dialog v-model="dialog" persistent max-width="500px">
            <v-card>
                <v-card-title>
                    <span class="headline">Add New Account</span>
                </v-card-title>
                <v-card-text>
                    <v-container grid-list-md>
                        <v-layout wrap>
                            <v-flex xs12>
                                <v-text-field
                                    v-model="name"
                                    :rules="nameRules"
                                    :counter="10"
                                    label="Account Name"
                                    required
                                ></v-text-field>
                            </v-flex>
                            <v-flex xs12>
                                <v-text-field
                                    v-model="parentAccount"
                                    :rules="parentAccountRules"
                                    :counter="10"
                                    label="Parent Account Name"
                                ></v-text-field>
                            </v-flex>
                            <v-flex xs12>
                                <v-text-field
                                    v-model="balance"
                                    :rules="balanceRules"
                                    :counter="10"
                                    label="Balance"
                                ></v-text-field>
                            </v-flex>
                            <v-flex xs12>
                                <v-select
                                    v-model="accountType"
                                    :rules="accountTypeRules"
                                    :items="accountTypeNames"
                                    item-text="name"
                                    item-value="id"
                                    label="Account Type"
                                    required
                                ></v-select>
                            </v-flex>
                        </v-layout>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                        <v-btn color="blue darken-1" flat @click.native="dialog = false">Close</v-btn>
                        <v-btn color="blue darken-1" flat @click.native="addAccount">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-layout>
</template>

<script>
    import _ from 'lodash'
    import gql from 'graphql-tag'
    import { ADD_ACCOUNT } from '@/graphql'

    export default {
        name: 'add-account',
        data () {
            return {
                valid: false,
                dialog: true,
                name: '',
                nameRules: [
                    v => !!v || 'Account name is required',
                    v => v.length <=10 || 'Account name must be less than 10 characters'
                ],
                parentAccount: null,
                parentAccountRules: [
                ],
                balance: '',
                balanceRules: [
                    v => !!v || 'Current balance is required',
                    v => v.length <=10 || 'Current balance must be less than 10 characters'
                ],
                accountType: null,
                accountTypeNames: [],
                accountTypeRules: [],
                // accountTypesLoading: false
            }
        },
        methods: {
            addAccount () {
                this.$apollo
                    .mutate({
                        mutation: ADD_ACCOUNT,
                        variables: {
                            name: this.name,
                            balance: this.balance,
                            accountTypeId: this.accountType,
                            parentAccountId: this.parentAccount
                        }
                    })
                    .then(response => {
                        this.$router.replace('/accounts')
                    })
            }
        },
        mounted () {
            this.$apollo.query({
                query: gql`
                    {
                        allAccountTypes {
                            nodes {
                                id
                                name
                            }
                        }
                    }
                `
            }).then(response => {
            let records = response.data.allAccountTypes.nodes
            _.forEach(records, record => {
                this.accountTypeNames.push({id: record.id, name: record.name})
            })
            })
        }
    }
</script>
