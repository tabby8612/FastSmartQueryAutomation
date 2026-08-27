import { BrowserRouter, Routes, Route } from 'react-router-dom'
import LoginPage from './pages/Login'
import Dashboard from "./pages/Dashboard"
import { AuthProvider } from "./contexts/auth-context"
import { ProtectedRoute } from "./components/protected-route"
import SubmitIssue from './pages/student/SubmitIssue'
import { MyIssues } from './pages/student/MyIssues'
import { OfficerIssues } from './pages/officer/OfficerIssues'
import { AdminIssues } from './pages/admin/AdminIssues'
import { Users } from './pages/admin/Users'
import { Categories } from './pages/admin/Categories'
import { Departments } from './pages/admin/Departments'
function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<LoginPage />} />
          <Route
            path="/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />
          <Route
            path="/student/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />
          <Route
            path="/officer/dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/dashboard"
            element={
                <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
              
            }
          />
          <Route
            path="/student/my-issues"
            element={
              <ProtectedRoute>
                <MyIssues />
              </ProtectedRoute>
            }
          />
          <Route
            path="/officer/issues"
            element={
              <ProtectedRoute>
                <OfficerIssues />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/issues"
            element={
              <ProtectedRoute>
                <AdminIssues />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/users"
            element={
              <ProtectedRoute>
                <Users />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/categories"
            element={
              <ProtectedRoute>
                <Categories />
              </ProtectedRoute>
            }
          />
          <Route
            path="/admin/department"
            element={
              <ProtectedRoute>
                <Departments />
              </ProtectedRoute>
            }
          />
          <Route path="/student/submit-issue" element={<SubmitIssue />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
