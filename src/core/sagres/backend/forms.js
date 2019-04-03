import qs from 'querystring'
import configuration from '../configuration'

const useLoginForm = ({ username, password }) => qs.stringify({
    ctl00$PageContent$LoginPanel$UserName: username,
    ctl00$PageContent$LoginPanel$Password: password,
    ctl00$PageContent$LoginPanel$LoginButton: 'Entrar',
    __EVENTTARGET: '',
    __EVENTARGUMENT: '',
    __VIEWSTATE: configuration.LOGIN_VIEW_STATE,
    __VIEWSTATEGENERATOR: configuration.LOGIN_VW_STT_GEN,
    __EVENTVALIDATION: configuration.LOGIN_VIEW_VALID
})

export default useLoginForm
