import axios from 'axios'
import axiosCookieJarSupport from 'axios-cookiejar-support'
import tough from 'tough-cookie-no-native'

import useLoginForm from './forms'
import configuration from '../configuration'

// Requests and Responses all of them, comes through here
class SagresAPI {
    constructor() {
        this.cookieJar = new tough.CookieJar()
        this.axios = axios.create({
            baseURL: configuration.SAGRES_BASE_URL,
            timeout: 120000, // UNES waits for 2 minutes...
            withCredentials: true,
            maxRedirects: 20,
            jar: this.cookieJar,
            headers: {
                // We are Google Chrome, or kind of it
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36',
                // Mimics the base requests to Sagres
                'Cache-Control': 'no-cache',
                // It's url encoded params
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        })

        axiosCookieJarSupport(axios)

        this.axios.interceptors.request.use((request) => {
            console.log('going to', request.url)
            return request
        })
    }

    login = ({ username, password }) => this.axios.post(
        configuration.SAGRES_LOGIN_URL,
        useLoginForm({ username, password })
    )

    messages = () => this.axios.get(configuration.SAGRES_MESSAGES_URL)
}

export default new SagresAPI()
