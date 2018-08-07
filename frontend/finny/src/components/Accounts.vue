<template>
<v-container fluid wrap>
    <v-layout>
    <v-flex xs12>
      <v-card>
        <v-toolbar color="teal" dark>

          <v-toolbar-title>Accounts</v-toolbar-title>

          <v-spacer></v-spacer>

          <v-btn icon>
            <v-icon>more_vert</v-icon>
          </v-btn>
        </v-toolbar>

        <v-list>
          <v-list-group
            v-for="item in items"
            :key="item.name"
            :prepend-icon="item.icon"
            no-action
          >
            <v-list-tile slot="activator">

                <v-list-tile-content >
                    <v-list-tile-title>{{ item.name }}</v-list-tile-title>
                </v-list-tile-content>
                <v-list-tile-action>
                    <v-btn @click="accountId(item.id)">
                        <v-icon>edit</v-icon>
                    </v-btn>
                </v-list-tile-action>

            </v-list-tile>



            <v-list-tile
              v-for="subItem in item.childAccounts"
              :key="subItem.name"
              xs2
            >
                <!-- <v-list-tile-avatar>
                    <v-icon>{{ subItemIcon }}</v-icon>
                </v-list-tile-avatar> -->
                <!-- <v-list-tile-action>
                    <v-checkbox v-model="childCheckbox"></v-checkbox>
                </v-list-tile-action> -->
                <v-list-tile-content>
                    <v-list-tile-title>{{ subItem.name }}</v-list-tile-title>
                    <v-list-tile-sub-title>{{ subItem.balance | toCurrency }}</v-list-tile-sub-title>
                </v-list-tile-content>
                <v-list-tile-action offset-xs12>
                    <v-btn @click="accountId(subItem.id)" v-model="editDialog">
                        <v-icon>edit</v-icon>
                    </v-btn>
                </v-list-tile-action>
            </v-list-tile>
          </v-list-group>
        </v-list>
      </v-card>
    </v-flex>
  </v-layout>
  <v-fade-transition>
    <v-dialog v-model="editDialog" persistent max-width="500px">
        <v-card>
            <v-card-title>
                <span class="headline">Edit Account</span>
            </v-card-title>
            <v-card-text>
                <v-container grid-list-md>
                    <v-layout wrap>
                        <v-flex xs12>
                            <v-text-field
                                v-model="name"
                                :rules="nameRules"
                                :counter="50"
                                label="Account Name"
                                required
                            ></v-text-field>
                        </v-flex>
                    </v-layout>
                </v-container>
            </v-card-text>
            <v-card-actions>
                <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" flat @click.native="editDialog = false">Close</v-btn>
                    <v-btn color="blue darken-1" flat @click.native="editAccount(id)">Save</v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
  </v-fade-transition>
</v-container>
</template>

<script>
    import _ from 'lodash'
    import gql from 'graphql-tag'
    import { EDIT_ACCOUNT } from '@/graphql'

    export default {
        data () {
            return {
                editDialog: false,
                checkbox: false,
                childCheckbox: false,
                subItemIcon: 'keyboard_arrow_right',
                items: [],
                icons: [
                    {account_type: 'Assets', icon: 'account_balance'},
                    {account_type: 'Liabilities', icon: 'credit_card'},
                    {account_type: 'Equity', icon: 'trending_up'}
                ],
                name: '',
                id: '',
                nameRules: [
                    v => !!v || 'Account name is required',
                    v => v.length <=50 || 'Account name must be less than 50 characters'
                ],
            }
        },
        methods: {
            editAccount ($id) {
                this.$apollo
                    .mutate({
                        mutation: EDIT_ACCOUNT,
                        variables: {
                            id: this.id,
                            name: this.name
                        },
                        refetchQueries: [
                            { query: gql`
                    {
                        allAccounts(filter: {
                            parentAccountId: {
                                isNull: true
                            }
                        }) {
                            nodes {
                                id
                                name
                                balance
                                accountsByParentAccountId{
                                    nodes {
                                        id
                                        name
                                        balance
                                    }
                                }
                                accountTypeByAccountTypeId {
                                    name
                                }
                            }
                        }
                    }
                `}]
                    }).then(response => {
                        this.editDialog = false
                    })
            },
            accountId: function(e) {
                let i=0, len=0
                if (e) {
                    console.log(e)
                    this.id = e
                    this.editDialog = true
                }
            },
        },
        mounted () {
            this.$apollo.query({
                query: gql`
                    {
                        allAccounts(filter: {
                            parentAccountId: {
                                isNull: true
                            }
                        }) {
                            nodes {
                                id
                                name
                                balance
                                accountsByParentAccountId{
                                    nodes {
                                        id
                                        name
                                        balance
                                    }
                                }
                                accountTypeByAccountTypeId {
                                    name
                                }
                            }
                        }
                    }
                `
            }).then(response => {
                let records = response.data.allAccounts.nodes
                _.forEach(records, record => {
                    let account_type = record.accountTypeByAccountTypeId.name
                    let icon = '', i=0, len=0
                    for (i=0, len=this.icons.length; i < len; i++) {
                        if (account_type == this.icons[i].account_type) {icon=this.icons[i].icon}
                    }
                    this.items.push({
                        id: record.id,
                        name: record.name,
                        balance: record.balance,
                        childAccounts: record.accountsByParentAccountId.nodes,
                        icon: icon,
                        checkbox: false
                    })
                })
            })
        }
    }
</script>
