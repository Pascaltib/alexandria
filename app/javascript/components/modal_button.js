const modalButtons = () => {
  var modal = document.querySelectorAll('.modal');

  var showModal = document.querySelectorAll('.show-modal');
  var closeModal = document.querySelectorAll('.close-modal');
  var showAddModal = document.querySelector('.show-add-modal')
  var closeAddModal = document.querySelector('.close-add-modal')
  var addModal = document.querySelector('.add-modal');

  if (showAddModal){
    showAddModal.addEventListener("click", function() {
      addModal.classList.remove("hidden")
    })
  }
  if (closeAddModal) {
    closeAddModal.addEventListener("click", function () {
      addModal.classList.add("hidden")
    })
  }


  if (showModal){
    showModal.forEach(element => {
      element.addEventListener('click', function () {
        modal.forEach(modal_element => {
          if(modal_element.dataset.cost_id){
            if (modal_element.dataset.cost_id == this.dataset.cost_id) {
              modal_element.classList.remove('hidden')
              console.log("modal popup from cost")
            }
          }
          else{
            modal_element.classList.remove('hidden')
            console.log("modal popup normal")
          }
        });

      // modal.classList.remove('hidden')
      });
    });
  };

  if(closeModal){
    closeModal.forEach(close => {
      close.addEventListener('click', function () {
        modal.forEach(modal_element => {
          if (modal_element.dataset.cost_id) {
            if (modal_element.dataset.cost_id == this.dataset.cost_id) {
              modal_element.classList.add('hidden')
            }
          }
          else {
            modal_element.classList.add('hidden')
          }
        });
      });
    });
  }
}
export { modalButtons };
