import dotenv from 'dotenv'
dotenv.config()

export default {
    isProduction: process.env.ENV === 'production',
    dbUrl: process.env.DATABASE_URL + '?ssl=1',
    dbSchema: process.env.DATABASE_SCHEMA || 'public',
    port: process.env.PORT || 5000,
    jwtSecret: process.env.JWT_SECRET,
    // jwtTokenIdentifier: 'tokens.jwt_token',
}
