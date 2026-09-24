import './globals.css';
export const metadata = {
  title: 'KeMinQ + EVAN — Query the data. Calculate the quotient.',
  description: 'Isulu 4157 blocks 5.61MT @7.04=1.27Moz exact GxW1317 Isulu1519 + Mui 16037 400MT + Kwale Ti 56km2 26% global',
};
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body style={{ margin: 0, background: '#0A1628', color: 'white' }}>{children}</body>
    </html>
  );
}
