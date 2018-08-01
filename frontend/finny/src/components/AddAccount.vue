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
                        </v-layout>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                        <v-btn color="blue darken-1" flat @click.native="dialog = false">Close</v-btn>
                        <v-btn color="blue darken-1" flat @click.native="dialog = false">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-layout>
</template>

<script>
    export default {
        name: 'add-account',
        data: () => ({
            valid: false,
            dialog: true,
            name: '',
            nameRules: [
                v => !!v || 'Account name is required',
                v => v.length <=10 || 'Account name must be less than 10 characters'
            ],
            parentAccount: '',
            parentAccountRules: [
                v => v.length <=10 || 'Account name must be less than 10 characters'
            ],
            balance: '',
            balanceRules: [
                v => !!v || 'Current balance is required',
                v => v.length <=10 || 'Current balance must be less than 10 characters'
            ],
        })
    }
        // methods: {
        //     addAccount () {
        //         let rows = []
        //         _.forEach(this.)
</script>
