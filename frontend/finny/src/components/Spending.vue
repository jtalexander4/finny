<template>
    <v-container fluid wrap>
        <v-layout>
            <v-flex xs12>
                <highcharts class="stock" :constructor-type="'stockChart'" :options="stockOptions" :updateArgs="[true, false]" ref="chart"></highcharts>
            </v-flex>
        </v-layout>
        <v-list>
            <v-list-tile v-model="stockOptions"><v-list-tile-title>{{ stockOptions.series }}</v-list-tile-title></v-list-tile>
            <!-- <v-list-tile><v-list-tile-title>{{ item.amounts }}</v-list-tile-title></v-list-tile> -->
        </v-list>
    </v-container>

</template>

<script>
import _ from "lodash"
import gql from "graphql-tag"
import HighchartsVue from 'highcharts-vue'

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
                series: []
            }
        }
    },
    methods: {
        querySpending () {
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
                this.stockOptions.series = []
                _.forEach(items1, record => {
                    let name = ''
                    let amounts = []
                    _.forEach(record, amount => {
                        name = amount.name
                        amounts.push(amount.amount)
                    })
                    // this.stockOptions.series.push({
                    //     name: name,
                    //     data: amounts,
                    // })
                    this.$refs.chart.chart.addSeries({
                        name: name,
                        data: amounts,
                    })
                })
                console.log(this.$refs.chart)

                // this.$refs.chart.chart.series[0].setData(this.stockOptions.series, true)
            })
        }
    },
    created() {
        this.querySpending()

            // _.forEach(records, record => {
            //     let name = record.name
            //     // this.items.push({"name": record.name, "data": record[key]})
            //     this.items.push({
            //         name: record.name,
            //         amount: record.amount
            //     })
            // })
            // this.stockOptions.series = this.items
    }
}
</script>
