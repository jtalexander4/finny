<template>
    <v-container fluid wrap>
        <v-layout>
            <v-flex xs12>
                <highcharts class="chart" :options="chartOptions" :updateArgs="[true, false]" ref="chart"></highcharts>
                <v-text></v-text>
            </v-flex>
        </v-layout>
    </v-container>

</template>

<script>
import _ from "lodash"
import gql from "graphql-tag"

export default {
    data() {
        return {
            chartOptions: {
                chart: {
                    type: 'spline'
                },
                title: {
                    text: "Total Spending"
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
                        allTransactionLines {
                            nodes {
                                accountByAccountId {
                                    id 
                                    name
                                }
                                amount
                            }
                        }
                    }
                `
            }).then(response => {
                let records = response.data.allTransactionLines.nodes
                let categories = _.groupBy(records, 'accountByAccountId.name')
                _.forEach(categories, category => {
                    let name = ''
                    let amounts = []
                    _.forEach(category, amount => {
                        name = amount.accountByAccountId.name
                        amounts.push(amount.amount)
                    })
                    this.$refs.chart.chart.addSeries({
                        name: name,
                        data: amounts,
                    })
                    console.log(this.$refs.chart.chart)
                    console.log(amounts)
                })
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
