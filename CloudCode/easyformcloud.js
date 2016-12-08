
Parse.Cloud.define("email", function(request, response) {
var Mandrill = require('mandrill');
Mandrill.initialize('MANDRILL_KEY');
Mandrill.sendEmail({
    message: {
        text: request.params.text,
        subject: "Parse and Mandrill!",
        from_email: "email@example.com",
        from_name: "Name",
        to: [
            {
                email: request.params.email,
                name: "Some Name"
            }
        ],
        attachments: [
            {
                "type": "application/pdf",
                "name": "easyform.pdf",
                "content": request.params.content
            }
        ]
    },
    async: true
},{
    success: function(httpResponse) {
        response.success("email sent");
    },
    error: function(httpResponse) {

    }
});
});
