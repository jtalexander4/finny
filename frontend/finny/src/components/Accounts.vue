<template>
  <v-container fluid wrap>
    <v-layout>
      <v-flex xs12>
        <v-card>
          <v-toolbar color="primary" dark>
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
              no-action>
              <v-list-tile slot="activator">
                <v-list-tile-action>
                  <v-btn
                    outline
                    @click="accountId(item.id)"
                    color="green"
                    fab
                    small
                    dark>
                    <v-icon>edit</v-icon>
                  </v-btn>
                </v-list-tile-action>
                <v-list-tile-action>
                  <v-btn
                    outline
                    color="red"
                    @click="deleteDialog=true"
                    fab
                    small
                    dark>
                    <v-icon>delete</v-icon>
                  </v-btn>
                </v-list-tile-action>
                <v-list-tile-content>
                  <v-list-tile-title>
                    {{ item.name }}
                  </v-list-tile-title>
                </v-list-tile-content>
              </v-list-tile>
              <v-list-tile
                v-for="subItem in item.childAccounts"
                :key="subItem.name"
                xs2>
                <v-list-tile-action>
                  <v-btn
                    outline
                    @click="accountId(subItem.id)"
                    v-model="editDialog"
                    color="green"
                    fab
                    small
                    dark>
                    <v-icon>edit</v-icon>
                  </v-btn>
                </v-list-tile-action>
                <v-list-tile-action>
                  <v-btn
                    outline
                    @click="deleteDialog=true"
                    color="red"
                    fab
                    small
                    dark>
                    <v-icon>delete</v-icon>
                  </v-btn>
                </v-list-tile-action>
                <v-list-tile-content>
                  <v-list-tile-title>
                    {{ subItem.name }}
                  </v-list-tile-title>
                  <v-list-tile-sub-title>
                    {{ subItem.balance | toCurrency }}
                  </v-list-tile-sub-title>
                </v-list-tile-content>
              </v-list-tile>
            </v-list-group>
          </v-list>
        </v-card>
      </v-flex>
      <v-btn
        fixed
        dark
        fab
        bottom
        right
        color="red"
        @click.native="addDialog=true">
        <v-icon>add</v-icon>
      </v-btn>
    </v-layout>
    <!-- add account -->
    <v-fade-transition>
      <v-dialog
        v-model="addDialog"
        persistent
        max-width="500px">
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
                    :counter="50"
                    label="Account Name"
                    required></v-text-field>
                </v-flex>
                <v-flex xs12>
                  <v-select
                    v-model="parentAccount"
                    :rules="parentAccountRules"
                    :items="parentAccountNames"
                    item-text="name"
                    item-value="id"
                    label="Parent Account Name"></v-select>
                </v-flex>
                <v-flex xs12>
                  <v-text-field
                    v-model="balance"
                    :rules="balanceRules"
                    :counter="50"
                    label="Balance"></v-text-field>
                </v-flex>
                <v-flex xs12>
                  <v-select
                    v-model="accountType"
                    :rules="accountTypeRules"
                    :items="accountTypeNames"
                    item-text="name"
                    item-value="id"
                    label="Account Type"
                    required></v-select>
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
              @click.native="addAccount()">Save</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-fade-transition>
    <!-- edit account -->
    <v-fade-transition>
      <v-dialog
        v-model="editDialog"
        persistent
        max-width="500px">
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
                    required></v-text-field>
                </v-flex>
                <v-flex xs12>
                  <v-select
                    v-model="parentAccount"
                    :rules="parentAccountRules"
                    :items="parentAccountNames"
                    item-text="name"
                    item-value="id"
                    label="Parent Account Name"></v-select>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              color="blue darken-1"
              flat
              @click.native="editDialog = false">Close</v-btn>
            <v-btn
              color="blue darken-1"
              flat
              @click.native="editAccount(id)">Save</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-fade-transition>
    <!-- delete account -->
    <v-fade-transition>
      <v-dialog v-model="deleteDialog" persistent max-width="290">
        <v-card>
          <v-card-title class="headline">Use Google's location service?</v-card-title>
          <v-card-text>Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running.</v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="green darken-1" flat @click.native="deleteDialog = false">Disagree</v-btn>
            <v-btn color="green darken-1" flat @click.native="deleteDialog = false">Agree</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-fade-transition>
  </v-container>
</template>

<script>
import _ from "lodash"
import gql from "graphql-tag"
import { ADD_ACCOUNT, EDIT_ACCOUNT } from "@/graphql"

export default {
  data() {
    return {
      editDialog: false,
      addDialog: false,
      deleteDialog: false,
      items: [],
      icons: [
        {
          account_type: "Assets",
          icon: "account_balance"
        },
        {
          account_type: "Liabilities",
          icon: "credit_card"
        },
        {
          account_type: "Equity",
          icon: "trending_up"
        }
      ],
      name: "",
      nameRules: [
        v => !!v || "Account name is required",
        v => v.length <= 50 || "Account name must be less than 50 characters"
      ],
      parentAccount: null,
      parentAccountRules: [],
      parentAccountNames: [],
      balance: "",
      balanceRules: [
        v => !!v || "Current balance is required",
        v => v.length <= 50 || "Current balance must be less than 50 characters"
      ],
      accountType: null,
      accountTypeNames: [],
      accountTypeRules: [],
      id: ""
    }
  },
  methods: {
    editAccount() {
      this.$apollo.mutate({
          mutation: EDIT_ACCOUNT,
          variables: {
            id: this.id,
            name: this.name,
            parentAccountId: this.parentAccount
          }
        })
        .then((this.editDialog = false), location.reload())
    },
    accountId: function(e) {
      if (e) {
        console.log(e)
        this.id = e
        this.editDialog = true
      }
    },
    addAccount() {
      this.$apollo.mutate({
        mutation: ADD_ACCOUNT,
        variables: {
          name: this.name,
          balance: this.balance,
          accountTypeId: this.accountType,
          parentAccountId: this.parentAccount
        }
      })
      .then((this.addDialog = false), location.reload())
    }
  },
  mounted() {
    this.$apollo
      .query({
        query: gql`
          {
            allAccounts(filter: { parentAccountId: { isNull: true } }) {
              nodes {
                id
                name
                balance
                accountsByParentAccountId {
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
          let icon = "",
            i = 0,
            len = 0
          for (i = 0, len = this.icons.length; i < len; i++) {
            if (account_type == this.icons[i].account_type) {
              icon = this.icons[i].icon
            }
          }
          this.items.push({
            id: record.id,
            name: record.name,
            balance: record.balance,
            childAccounts: record.accountsByParentAccountId.nodes,
            icon: icon,
          })
        })
      })
    this.$apollo
      .query({
        query: gql`
          {
            allAccounts(filter: { parentAccountId: { isNull: true } }) {
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
          this.parentAccountNames.push({
            id: record.id,
            name: record.name
          })
        })
      })
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
