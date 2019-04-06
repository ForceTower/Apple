import cheerio from 'react-native-cheerio'

const messageScrapper = async (data) => {
    const messages = []
    try {
        const $ = await cheerio.load(data)
        const articles = $('article')
        articles.each((index, element) => {
            const discipline = $('.recado-escopo', element).text()
            const time = $('.recado-data', element).text()
            const message = $('.recado-texto', element).text()
            const send = $('.recado-remetente', element)
            const sender = $('span', send).text()
            const feed = $(element)
            let type = 0
            if (feed.hasClass('recado-instituicao')) type = 1
            else if (feed.hasClass('recado-aluno')) type = 2

            const pack = {
                discipline,
                time,
                message,
                sender,
                type
            }

            messages.push(pack)
        })
        return Promise.resolve(messages)
    } catch (error) {
        return Promise.reject(new Error('error.unparseable.message'))
    }
}

export default messageScrapper
