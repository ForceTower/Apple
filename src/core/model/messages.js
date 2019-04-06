export default class Messages { }

Messages.schema = {
    name: 'messages',
    properties: {
        // scope is generally the discipline
        scope: 'string',
        received: 'string',
        message: 'string',
        sender: 'string',
        type: 'int'
    }
}
