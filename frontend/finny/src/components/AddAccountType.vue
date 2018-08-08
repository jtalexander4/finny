<template>
    <v-layout row justify-center>
        <v-dialog v-model="dialog" persistent max-width="500px">
            <v-card>
                <v-card-title>
                    <span class="headline">Add New Account Type</span>
                </v-card-title>
                <v-card-text>
                    <v-form v-model="valid">
                        <v-container grid-list-md>
                            <v-layout wrap>
                                <v-flex xs12>
                                    <v-text-field
                                        v-model="name"
                                        :rules="nameRules"
                                        :counter="10"
                                        label="Account Type Name"
                                        required
                                    ></v-text-field>
                                </v-flex>
                                <v-flex xs12>
                                    <v-checkbox
                                        v-model="creditPositive"
                                        :rules="creditPositiveRules"
                                        label="Is Credit Positive?"
                                        required
                                    ></v-checkbox>
                                </v-flex>
                            </v-layout>
                        </v-container>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                        <v-btn color="blue darken-1" flat @click.native="dialog = false">Close</v-btn>
                        <v-btn color="blue darken-1" flat @click.native="addAccountType">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-layout>
</template>

<script>
    import { ADD_ACCOUNT_TYPE } from '@/graphql'

    export default {
        name: 'add-account-type',
        data: () => ({
            valid: false,
            dialog: true,
            name: '',
            nameRules: [
                v => !!v || 'Account type name is required',
                v => v.length <=10 || 'Account type name must be less than 10 characters'
            ],
            creditPositive: true,
            creditPositiveRules: [
            ],
            // accountTypesLoading: false
        }),
        methods: {
            addAccountType () {
                this.$apollo
                    .mutate({
                        mutation: ADD_ACCOUNT_TYPE,
                        variables: {
                            name: this.name,
                            credit_positive: this.creditPositive
                        }
                    })
            }
        }
    }
</script>
