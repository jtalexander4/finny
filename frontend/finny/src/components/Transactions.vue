<template>
    <ag-grid-vue style="width: 300px; height: 500px;"
                 class="ag-theme-material"
                 :columnDefs="columnDefs"
                 :rowData="rowData"
                 :enableSorting="true"
                 :enableFilter="true"
                 rowSelection="multiple"
                 enableRangeSelection="true">
    </ag-grid-vue>
</template>

<script>
    import { AgGridVue } from "ag-grid-vue"
    import _ from "lodash"
    import gql from "graphql-tag"

    export default {
        name: 'App',
        data() {
            return {
                columnDefs: null,
                rowData: null
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
        }
    }
</script>