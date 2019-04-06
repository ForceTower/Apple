import SagresAPI from '../backend/index'
import messageScrapper from '../scrappers'

export default class Messages {
    static perform = async () => {
        const response = await SagresAPI.messages()
        const { data } = response
        if (data) {
            const messages = await messageScrapper(data)
            console.log(messages)
        }
    }
}
