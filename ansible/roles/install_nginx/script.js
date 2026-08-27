let count = 0;
const btn = document.getElementById("counter-btn");
const display = document.getElementById("counter-value");

btn.addEventListener("click", () => {
  count += 1;
  display.textContent = count;
});