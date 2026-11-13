import { BrowserRouter, Routes, Route } from "react-router-dom";
import LoginPage from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import { AuthProvider } from "./contexts/auth-context";
import { ProtectedRoute } from "./components/protected-route";
import { AdminIssues } from "./pages/admin/AdminIssues";
import { Users } from "./pages/admin/Users";
import { CreateStudent } from "./pages/admin/CreateStudent";
import { CreateOfficer } from "./pages/admin/CreateOfficer";
import { CreateAdmin } from "./pages/admin/CreateAdmin";
import { Categories } from "./pages/admin/Categories";
import { Departments } from "./pages/admin/Departments";
import GoogleCallback from "./pages/GoogleCallback";
import { TicketDetail } from "./pages/TicketDetail";
import { HodIssues } from "./pages/hod/HodIssues";
import { AdminDashboard } from "./pages/admin/AdminDashboard";
import { Announcement } from "./pages/admin/Announcement";
import CreateAnnouncement from "./pages/admin/CreateAnnouncement";
import { AuditLogs } from "./pages/admin/AuditLogs";
import { Account } from "./pages/Account";
import { SearchPage } from "./pages/Search";

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
