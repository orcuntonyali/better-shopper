document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.minus-plus').forEach(function(button) {
    button.addEventListener('click', function() {
      var itemId = this.dataset.itemId;
      var action = this.dataset.action;
      var quantityElement = document.getElementById('quantity_' + itemId);
      var currentQuantity = parseInt(quantityElement.innerText);

      if (action === 'increment') {
        quantityElement.innerText = currentQuantity + 1;
      } else if (action === 'decrement' && currentQuantity > 1) {
        quantityElement.innerText = currentQuantity - 1;
      }
    });
  });
});
