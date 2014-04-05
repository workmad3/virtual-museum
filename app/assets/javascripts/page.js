jQuery(document).ready(function ($) {
    $('#tabs').tab();
    });

function hide_and_show() {
    event.preventDefault();
    document.getElementById('new-comment-form-to-show').className = '';
    document.getElementById('button-to-hide').className = 'hiddenx';
}