<template>
    <v-container fluid wrap>
        <v-layout>
            <ag-grid-vue style="width: 400px; height: 500px;"
                        class="ag-theme-material"
                        :columnDefs="columnDefs"
                        :rowData="rowData"
                        :enableSorting="true"
                        :enableFilter="true"
                        rowSelection="multiple"
                        enableRangeSelection="true">
            </ag-grid-vue>
            <v-btn
                fixed
                dark
                fab
                bottom
                right
                color="green"
                @click.native="addDialog=true">
                <v-icon>add</v-icon>
            </v-btn>
        </v-layout>
        <!-- add transaction -->
        <v-fade-transition>
            <v-dialog 
                v-model="addDialog"
                persistent
                max-width="500px">
                <v-card>
                    <v-card-title>
                        <span class="headline">Add New Transaction</span>
                    </v-card-title>
                    <v-card-text>
                        <v-container grid-list-md>
                            <v-layout wrap>
                                <v-flex xs12>
                                    <v-autocomplete
                                        v-model="account"
                                        :rules="accountRules"
                                        :items="accountNames"
                                        item-text="name"
                                        persistent-hint
                                        item-value="id"
                                        label="Account">
                                    </v-autocomplete>
                                </v-flex>
                                <v-flex xs12>
                                    <v-text-field
                                        v-model="amount"
                                        :rules="amountRules"
                                        prefix="$"
                                        label="Amount">
                                    </v-text-field>
                                </v-flex>
                                <v-flex xs12>
                                    <v-autocomplete
                                        v-model="fiscalPeriod"
                                        :rules="fiscalPeriodRules"
                                        :items="fiscalPeriodNames"
                                        item-text="name"
                                        persistent-hint
                                        item-value="id"
                                        label="Fiscal Period">
                                    </v-autocomplete>
                                </v-flex>
                                <v-flex>
                                    <v-menu
                                        ref="dateMenu"
                                        :close-on-content-click="false"
                                        v-model="dateMenu"
                                        :nudge-right="40"
                                        :return-value.sync="datePosted"
                                        lazy
                                        transition="scale-transition"
                                        offset-y
                                        full-width
                                        min-width="290px"
                                    >
                                        <v-text-field
                                            slot="activator"
                                            v-model="datePosted"
                                            label="Picker in menu"
                                            prepend-icon="event"
                                            readonly
                                        ></v-text-field>
                                        <v-date-picker v-model="datePosted" no-title scrollable @input="$refs.dateMenu.save(datePosted)">
                                        </v-date-picker>
                                    </v-menu>
                                </v-flex>
                            </v-layout>
                        </v-container>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn
                            color="blue darken-1"
                            flat
                            @click.native="addDialog = false">Close</v-btn>
                        <v-btn
                            color="blue darken-1"
                            flat
                            @click.native="addTransaction()">Save</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </v-fade-transition>
    </v-container>
</template>

<script>
    import { AgGridVue } from "ag-grid-vue"
    import _ from "lodash"
    import gql from "graphql-tag"
    import { ADD_TRANSACTION_LINE } from "@/graphql"

    export default {
        name: 'App',
        data() {
            return {
                columnDefs: null,
                rowData: null,
                addDialog: false,
                dateMenu: false,
                account: null,
                accountNames: [],
                accountRules: [],
                amount: "",
                amountRules: [],
                fiscalPeriod: null,
                fiscalPeriodNames: [],
                fiscalPeriodRules: [],
                datePosted: "",
            }
        },
        components: {
            AgGridVue
        },
        beforeMount() {
            this.columnDefs = [
                {headerName: 'Name', field: 'name', checkboxSelection: true},
                {headerName: 'Amount', field: 'amount'},
            ]
            this.rowData = []
            this.$apollo
                .query({
                    query: gql`
                        {
                            allTestings {
                                nodes {
                                    name
                                    amount 
                                }
                            }
                        }
                    `
                }).then(response => {
                    let records = response.data.allTestings.nodes
                    _.forEach(records, record => {
                        this.rowData.push({
                            name: record.name,
                            amount: record.amount
                        })
                    })
                })
        },
        methods: {
            addTransaction() {
                this.$apollo.mutate({
                    mutation: ADD_TRANSACTION_LINE,
                    variables: {
                        accountId: this.account,
                        amount: this.amount,
                        fiscalPeriodId: this.fiscalPeriod,
                        datePosted: this.datePosted
                    }
                })
                .then((this.addDialog = false), location.reload())
            },
        },
        mounted() {
            this.$apollo.query({
                query: gql`
                    {
                        allAccounts {
                            nodes {
                                id
                                name
                            }
                        }
                    }
                `
            }).then(response => {
                let records = response.data.allAccounts.nodes
                _.forEach(records, record => {
                    this.accountNames.push({id: record.id, name: record.name})
                })
            })
            this.$apollo.query({
                query: gql`
                    {
                        allFiscalPeriods {
                            nodes {
                                id
                                name
                            }
                        }
                    }
                `
            }).then(response => {
                let records = response.data.allFiscalPeriods.nodes
                _.forEach(records, record => {
                    this.fiscalPeriodNames.push({id: record.id, name: record.name})
                })
            })
        }
    }
</script>