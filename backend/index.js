import colors from 'colors'
import express from 'express'
import expressPlayground from 'graphql-playground-middleware-express'
import {postgraphile} from 'postgraphile'
import PostGraphileConnectionFilterPlugin from 'postgraphile-plugin-connection-filter'
import PostGraphileDerivedFieldPlugin from 'postgraphile-plugin-derived-field'
import config from './config'

const app = express()

let notificationEntries = [
    `Finny API - ${config.isProduction ? 'Production'.red : 'Development'.cyan}`.bold,
    '',
]

app.use(
    postgraphile(config.dbUrl, config.dbSchema, {
        watchPg: true,
        enableCors: true,
        disableQueryLog: config.isProduction,
        showErrorStack: !config.isProduction,
        appendPlugins: [PostGraphileConnectionFilterPlugin, PostGraphileDerivedFieldPlugin],
    })
)
notificationEntries.push(
    `endpoint running at http://localhost:${config.port}/graphql`.green.bold
)

if (!config.isProduction) {
    app.get('/playground', expressPlayground({endpoint: '/graphql'}))
    notificationEntries.push(
        `playground running at http://localhost:${config.port}/playground`.cyan.bold
    )
}

console.log(notificationEntries.join('\n'))

app.listen(config.port)
