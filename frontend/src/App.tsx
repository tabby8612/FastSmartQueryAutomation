import { BrowserRouter, Routes, Route } from "react-router-dom";
import LoginPage from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import { AuthProvider } from "./contexts/auth-context";
import { ProtectedRoute } from "./components/protected-route";
import GoogleCallback from "./pages/GoogleCallback";
import { TicketDetail } from "./pages/TicketDetail";

import studentRoutes from "@/routes/studentRoutes";
import officerRoutes from "@/routes/officerRoutes";
import hodRoutes from "@/routes/hodRoutes";
import adminRoutes from "@/routes/adminRoutes";

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {studentRoutes}
          {officerRoutes}
          {hodRoutes}
          {adminRoutes}

          <Route
            path="/ticket/:ticketId"
            element={
              <ProtectedRoute>
                <TicketDetail />
              </ProtectedRoute>
            }
          />
          <Route path="/" element={<LoginPage />} />

          <Route path="/auth/callback" element={<GoogleCallback />} />
          
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
