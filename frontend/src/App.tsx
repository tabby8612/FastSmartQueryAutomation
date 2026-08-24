import { BrowserRouter, Routes, Route } from 'react-router-dom'
import LoginPage from './pages/Login'
import Dashboard from "./pages/Dashboard"
import { AuthProvider } from "./contexts/auth-context"
import { ProtectedRoute } from "./components/protected-route"
import SubmitIssue from './pages/student/SubmitIssue'
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
          <Route path="/submit-issue" element={<SubmitIssue />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
