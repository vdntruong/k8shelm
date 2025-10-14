package main

import (
	"encoding/json"
	"net/http"
)

// welcome xử lý request tại root path.
func welcomeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	response := map[string]string{"message": "Welcome from the Go service using Functions Framework!"}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}


// health xử lý request kiểm tra "sức khỏe" của service.
func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	response := map[string]string{"status": "ok"}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}
