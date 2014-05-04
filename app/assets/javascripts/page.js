jQuery(document).ready(function ($) {
    $('#tabs').tab();
});

function hide_and_show() {
    event.preventDefault();
    document.getElementById('new-comment-form-to-show').className = '';
    document.getElementById('button-to-unhide').className = 'hiddenx';
}

function help_dialog() {
    event.preventDefault();
    $("#dialog").dialog({
        position: {
            my: "right bottom",
            at: "right bottom",
            of: window
        },
        width: '600px'
    })
}

