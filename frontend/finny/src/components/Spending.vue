<template>
    <v-container fluid wrap>
        <!-- <v-layout>
            <v-flex xs12>
                <highcharts class="stock" :constructor-type="'stockChart'" :options="stockOptions"></highcharts>
            </v-flex>
        </v-layout> -->
        <v-list>
            <v-list-tile v-for="item in items" :key="item.name"><v-list-tile-title>{{ item.name }}</v-list-tile-title></v-list-tile>
            <!-- <v-list-tile><v-list-tile-title>{{ item.amounts }}</v-list-tile-title></v-list-tile> -->
        </v-list>
    </v-container>

</template>

<script>
import _ from "lodash"
import gql from "graphql-tag"

export default {
    data() {
        return {
            items: [],
            stockOptions: {
                rangeSelector: {
                    selected: 1
                },
                title: {
                    text: "AAPL Stock Price"
                },
                series: [{
                    name: "AAPL",
                    data: [10, 20, 10, 23, 65, 121, 44, 66, 98, 30, 32, 56, 25, 12, 53],
                    pointStart: Date.UTC(2018, 1, 1),
                    pointInterval: 1000 * 3600 * 24,
                    tooltip: {
                        valueDecimals: 2
                    }
                }]
            }
        }
    },
    mounted() {
        this.$apollo.query({
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
            let items1 = _.groupBy(records, 'name')
            _.forEach(items1, record => {
                let name = ''
                let amounts = []
                _.forEach(record, amount => {
                    name = amount.name
                    amounts.push(amount.amount)
                })
                this.items.push({
                    name: name,
                    amounts: amounts,
                })
            })


            // _.forEach(records, record => {
            //     let name = record.name
            //     // this.items.push({"name": record.name, "data": record[key]})
            //     this.items.push({
            //         name: record.name,
            //         amount: record.amount
            //     })
            // })
        })
    }
};
</script>
