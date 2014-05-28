jQuery(document).ready(function ($) {
    $('#tabs').tab();
    $("#new-comment-form-to-show").on("click", hide_and_show);
});

function hide_and_show(event) {
    event.preventDefault();
    $(event.target).hide();
    $("#'button-to-unhide").show();
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

