import cheerio from 'react-native-cheerio'

import SagresAPI from '../backend'

export default class Login {
    static perform = async ({ username, password }) => {
        try {
            const response = await SagresAPI.login({ username, password })
            const { data } = response
            if (data) {
                const $ = await cheerio.load(data)
                const name = await $('.topo-info-login .usuario-nome').text()
                console.log(name)
                if (name) {
                    return Promise.resolve(name)
                }
                return Promise.reject(new Error('error.login.data.invalid'))
            }
            return Promise.reject(new Error(''))
        } catch (err) {
            // TODO Better handling of errors
            console.log(err)
            Promise.reject(new Error('error.network.failed'))
        }

        return Promise.reject(new Error('error.login.undefined'))
    }
}
